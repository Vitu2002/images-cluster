import { Injectable, Logger, OnModuleInit } from '@nestjs/common';
import BackBlazeB2 from 'backblaze-b2';

@Injectable()
export class StorageService extends BackBlazeB2 implements OnModuleInit {
    private readonly logger = new Logger('Storage B2');
    status: string;
    constructor() {
        super({
            applicationKey: process.env.B2_SECRET,
            applicationKeyId: process.env.B2_KEY
        });
    }

    async onModuleInit() {
        await this.auth();
        setInterval(() => this.auth(), 1000 * 60 * 60 * 23.5);
    }

    async auth() {
        try {
            await this.authorize();
            this.logger.log('Connected');
            this.status = 'connected';
        } catch (e) {
            this.logger.error(e.message);
            this.status = 'disconnected: ' + e.message;
        }
    }
}
