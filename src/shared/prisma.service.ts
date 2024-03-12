import { Injectable, Logger, OnModuleInit } from '@nestjs/common';
import { PrismaClient } from '@prisma/client';

@Injectable()
export class PrismaService extends PrismaClient implements OnModuleInit {
    private logger = new Logger('Prisma');

    constructor() {
        super({ errorFormat: 'pretty' });
    }

    async onModuleInit() {
        this.$connect()
            .then(() => this.logger.log('Connected'))
            .catch(err => this.logger.error(err.message));
    }
}
