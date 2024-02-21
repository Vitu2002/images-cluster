import { INestApplication, Injectable, Logger, OnModuleInit } from '@nestjs/common';
import type { RedisCommandArgument } from '@redis/client/dist/lib/commands';
import { SetOptions, createClient } from 'redis';

@Injectable()
export class RedisService implements OnModuleInit {
    private readonly redis = createClient({
        name: 'yomu-api',
        password: process.env.REDIS_PASSWORD,
        socket: {
            host: process.env.REDIS_HOST,
            port: process.env.REDIS_PORT
        }
    });
    private logger = new Logger('Redis');
    readonly get = (key: RedisCommandArgument) => this.redis.get(key);
    readonly set = (
        key: RedisCommandArgument,
        value: RedisCommandArgument | number,
        options: SetOptions
    ) => this.redis.set(key, value, options);
    readonly del = (key: RedisCommandArgument | RedisCommandArgument[]) => this.redis.del(key);
    readonly keys = (key: RedisCommandArgument) => this.redis.keys(key);
    readonly sAdd = (
        key: RedisCommandArgument,
        members: RedisCommandArgument | RedisCommandArgument[]
    ) => this.redis.sAdd(key, members);
    readonly sMembers = (key: RedisCommandArgument) => this.redis.sMembers(key);
    readonly sRem = (
        key: RedisCommandArgument,
        members: RedisCommandArgument | RedisCommandArgument[]
    ) => this.redis.sRem(key, members);
    readonly sIsMember = (key: RedisCommandArgument, member: RedisCommandArgument) =>
        this.redis.sIsMember(key, member);
    readonly expire = (
        key: RedisCommandArgument,
        seconds: number,
        mode?: 'NX' | 'XX' | 'GT' | 'LT'
    ) => this.redis.expire(key, seconds, mode);
    readonly hDel = (
        key: RedisCommandArgument,
        field: RedisCommandArgument | RedisCommandArgument[]
    ) => this.redis.hDel(key, field);
    readonly hExists = (key: RedisCommandArgument, field: RedisCommandArgument) =>
        this.redis.hExists(key, field);
    readonly hKeys = (key: RedisCommandArgument) => this.redis.hKeys(key);
    readonly hLen = (key: RedisCommandArgument) => this.redis.hLen(key);
    readonly hGet = (key: RedisCommandArgument, field: RedisCommandArgument) =>
        this.redis.hGet(key, field);
    readonly hGetAll = (key: RedisCommandArgument) => this.redis.hGetAll(key);
    readonly hSet = (
        key: RedisCommandArgument,
        field: RedisCommandArgument | number,
        value: RedisCommandArgument | number
    ) => this.redis.hSet(key, field, value);
    status: string;

    async onModuleInit() {
        await this.redis
            .connect()
            .then(() => {
                this.logger.log('Connected');
                this.status = 'connected';
            })
            .catch(err => {
                this.logger.error(err?.message);
                this.status = 'disconnected: ' + err?.message;
            });
    }

    async enableShutdownHooks(app: INestApplication) {
        this.redis.on('disconnect', async () => {
            this.logger.error('Closing connection');
            await app.close();
        });
    }
}
