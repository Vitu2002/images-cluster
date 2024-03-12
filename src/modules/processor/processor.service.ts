import {
    BadRequestException,
    Injectable,
    InternalServerErrorException,
    Logger,
    ServiceUnavailableException,
    UnauthorizedException
} from '@nestjs/common';
import { PrismaService } from '@shared/prisma.service';
import { RedisService } from '@shared/redis.service';
import { StatusService } from '@shared/status.service';
import { StorageService } from '@shared/storage.service';
import { readFile } from 'fs/promises';
import imageSize from 'image-size';
import sharp from 'sharp';

@Injectable()
export class ProcessorService {
    private readonly logger = new Logger('Images');
    constructor(
        private readonly redis: RedisService,
        private readonly prisma: PrismaService,
        private readonly storage: StorageService,
        private readonly status: StatusService
    ) {}

    async auth(hash: string): Promise<HashData> {
        const key = `processor:${hash}`;
        const cache = await this.redis.get(key);
        if (!cache) throw new UnauthorizedException('Hash is not valid');
        return JSON.parse(cache);
    }

    async upload(hash: string, image: Express.Multer.File) {
        if (!image) throw new BadRequestException('Missing image');
        const auth = await this.auth(hash);
        if (auth.mime !== image.mimetype) throw new BadRequestException('Mime type is not valid');
        if (auth.size !== image.size) throw new BadRequestException('Size is not valid');
        this.status.processes('queue');
        const processed = await this.processImage(image.path, auth);
        this.logger.log(`Uploading ${processed.name} (${processed.size / 1024}KB) | HASH: ${hash}`);
        const uploaded = await this.uploadFile(processed.image, processed);
        this.logger.log(`Uploaded ${processed.name} (${processed.size / 1024}KB) | HASH: ${hash}`);
        this.status.processes('uploads');
        await this.prisma.images.create({
            data: {
                b2: uploaded.b2,
                uri: uploaded.name,
                size: uploaded.size,
                width: uploaded.width,
                height: uploaded.height,
                mime: uploaded.mimetype,
                type: auth.type,
                v: auth.v,
                manga_entity_cover: auth.manga_entity_cover,
                manga_entity_banner: auth.manga_entity_banner,
                chapter_entity_page: auth.chapter_entity_page,
                user_entity_avatar: auth.user_entity_avatar,
                user_entity_banner: auth.user_entity_banner,
                scan_entity_icon: auth.scan_entity_icon,
                scan_entity_banner: auth.scan_entity_banner
            }
        });
        this.status.processes('queue', -1);
        return uploaded;
    }

    async uploadFile(image: Buffer, data: HashData) {
        const maxAttempts = 10;
        let attempt = 1;

        while (attempt <= maxAttempts) {
            try {
                const { data: bucket } = await this.storage.getUploadUrl({
                    bucketId: process.env.B2_BUCKET
                });

                const { data: uploaded } = await this.storage.uploadFile({
                    data: image,
                    fileName: data.name,
                    uploadUrl: bucket.uploadUrl,
                    uploadAuthToken: bucket.authorizationToken,
                    mime: data.mime
                });

                return {
                    b2: uploaded.fileId as string,
                    name: uploaded.fileName as string,
                    size: data.size,
                    width: data.width,
                    height: data.height,
                    mimetype: data.mime
                };
            } catch (error) {
                this.logger.error(`Error in image upload attempt ${attempt}: ${error.message}`);
                await new Promise(resolve => setTimeout(resolve, 1000 * attempt));
                attempt++;
            }
        }

        this.status.processes('errors');
        this.status.processes('queue', -1);
        this.logger.error(`Failed to upload image after ${maxAttempts} attempts.`);
        throw new ServiceUnavailableException('Failed to upload image');
    }

    async processImage(path: string, data: HashData) {
        try {
            const image = sharp(await readFile(path));
            this.logger.log(
                `Processing image ${path} (${(await image.metadata()).size / 1024}KB) | HASH: ${data.id}`
            );

            if (data.width || data.height) image.resize(data.width, data.height);

            const processed = await image
                .toFormat((data.format as 'avif') || 'avif', { quality: data.quality })
                .toBuffer();
            const metadata = imageSize(processed);
            return {
                id: data.id,
                name: data.name.split('.').slice(0, -1).join('.') + '.' + metadata.type,
                mime: 'image/' + metadata.type,
                width: metadata.width,
                height: metadata.height,
                size: processed.byteLength,
                quality: data.quality,
                image: processed,
                type: data.type
            };
        } catch (e) {
            this.status.processes('errors');
            this.status.processes('queue', -1);
            this.logger.error(`Failed to process image ${path}: ${e.message}`);
            throw new InternalServerErrorException('Failed to process image');
        }
    }
}
