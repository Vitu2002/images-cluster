import { Controller, Get } from '@nestjs/common';
import { StatusService } from '@shared/status.service';

@Controller('status')
export class StatusController {
    constructor(private readonly manager: StatusService) {}

    async init() {
        await this.manager.init();
    }

    @Get()
    async getStatus() {
        return this.manager.health();
    }
}
