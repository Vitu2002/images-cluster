import { ProcessorModule } from '@modules/processor/processor.module';
import { StatusModule } from '@modules/status/status.module';
import { Module } from '@nestjs/common';

@Module({
    imports: [StatusModule, ProcessorModule]
})
export class AppModule {}
