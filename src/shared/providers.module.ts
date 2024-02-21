import { Module } from '@nestjs/common';
import { RedisService } from './redis.service';
import { StatusService } from './status.service';
import { StorageService } from './storage.service';

@Module({
    providers: [RedisService, StorageService, StatusService],
    exports: [RedisService, StorageService, StatusService]
})
export class ProvidersModule {}
