import { Module } from '@nestjs/common';
import { PrismaService } from './prisma.service';
import { RedisService } from './redis.service';
import { StatusService } from './status.service';
import { StorageService } from './storage.service';

@Module({
    providers: [RedisService, PrismaService, StorageService, StatusService],
    exports: [RedisService, PrismaService, StorageService, StatusService]
})
export class ProvidersModule {}
