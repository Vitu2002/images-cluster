export {};

declare global {
    namespace NodeJS {
        interface ProcessEnv {
            NODE_ENV: 'development' | 'production' | 'test';
            PORT: number;
            HOST: number;

            // Cache (Redis)
            REDIS_HOST: string;
            REDIS_PORT: number;
            REDIS_PASSWORD: string;

            // Storage (Backblaze)
            B2_KEY: string;
            B2_SECRET: string;
            B2_BUCKET: string;
        }
    }
}
