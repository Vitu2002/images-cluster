import { Module } from '@nestjs/common';
import { ProvidersModule } from '@shared/providers.module';
import { StatusController } from './status.controller';

@Module({
    imports: [ProvidersModule],
    controllers: [StatusController]
})
export class StatusModule {}
