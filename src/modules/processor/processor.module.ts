import { Module } from '@nestjs/common';
import { ProvidersModule } from '@shared/providers.module';
import { ProcessorController } from './processor.controller';
import { ProcessorService } from './processor.service';

@Module({
    imports: [ProvidersModule],
    providers: [ProcessorService],
    controllers: [ProcessorController]
})
export class ProcessorModule {}
