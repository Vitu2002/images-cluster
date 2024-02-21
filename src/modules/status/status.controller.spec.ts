import { Test, TestingModule } from '@nestjs/testing';
import { ProvidersModule } from '@shared/providers.module';
import { StatusController } from './status.controller';

describe('StatusController', () => {
    let statusController: StatusController;

    beforeAll(async () => {
        const app: TestingModule = await Test.createTestingModule({
            imports: [ProvidersModule],
            controllers: [StatusController]
        }).compile();

        statusController = app.get<StatusController>(StatusController);
        // Aguarde a conclusão das conexões (pode depender da implementação específica)
        await statusController.init(); // ou outro método que estabelece conexões
    });

    describe('status', () => {
        it('should return services connected', async () => {
            const result = await statusController.getStatus();

            expect(result.services).toEqual({
                redis: 'connected',
                storage: 'connected'
            });
        });
    });
});
