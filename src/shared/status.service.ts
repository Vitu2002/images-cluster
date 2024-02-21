import { Injectable } from '@nestjs/common';
import os from 'os-utils';
import { RedisService } from './redis.service';
import { StorageService } from './storage.service';

@Injectable()
export class StatusService {
    private queue = 0;
    private errors = 0;
    private uploads = 0;

    constructor(
        private readonly redis: RedisService,
        private readonly storage: StorageService
    ) {}

    async init() {
        await this.redis.onModuleInit();
        await this.storage.onModuleInit();
    }

    async health() {
        return {
            cpu: await this.cpu(),
            mem: this.mem(),
            services: this.services(),
            processes: {
                queue: this.queue,
                errors: this.errors,
                uploads: this.uploads
            }
        };
    }

    processes(type: 'queue' | 'errors' | 'uploads', value = 1) {
        switch (type) {
            case 'queue':
                this.queue += value;
                break;
            case 'errors':
                this.errors += value;
                break;
            case 'uploads':
                this.uploads += value;
                break;
        }
    }

    async cpu() {
        const usage = await new Promise<number>(res => os.cpuUsage(value => res(value)));
        return {
            cpus: os.cpuCount(),
            usage: usage.toFixed(2) + '%',
            avg: os.loadavg(5) + '%'
        };
    }

    mem() {
        return {
            total: this.format(os.totalmem()),
            usage: this.format(os.freemem())
        };
    }

    services() {
        return {
            redis: this.redis.status,
            storage: this.storage.status
        };
    }

    private format(mb: number) {
        return mb > 1024 ? (mb / 1024).toFixed(2) + 'GB' : mb.toFixed(2) + 'MB';
    }
}
