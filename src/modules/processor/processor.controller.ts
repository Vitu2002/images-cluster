import { Controller, Param, Post, UploadedFile, UseInterceptors } from '@nestjs/common';
import { FileInterceptor } from '@nestjs/platform-express';
import multer from 'multer';
import { ProcessorService } from './processor.service';

@Controller('processor')
export class ProcessorController {
    constructor(private readonly manager: ProcessorService) {}

    @Post(':hash')
    @UseInterceptors(
        FileInterceptor('image', {
            storage: multer.diskStorage({
                filename(req, file, callback) {
                    callback(null, `${req.params.hash}.${file.originalname.split('.').pop()}`);
                }
            }),
            limits: {
                fileSize: 1024 * 1024 * 10
            }
        })
    )
    async Upload(@Param('hash') hash: string, @UploadedFile() image: Express.Multer.File) {
        return await this.manager.upload(hash, image);
    }
}
