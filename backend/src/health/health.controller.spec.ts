import { HealthController } from './health.controller';
import { PrismaService } from '../prisma/prisma.service';
import { RedisService } from '../redis/redis.service';

function build(dbOk: boolean, redisOk: boolean) {
  const prisma = {
    $queryRaw: dbOk
      ? jest.fn().mockResolvedValue([{ '?column?': 1 }])
      : jest.fn().mockRejectedValue(new Error('db down')),
  } as unknown as PrismaService;
  const redis = {
    client: {
      ping: redisOk
        ? jest.fn().mockResolvedValue('PONG')
        : jest.fn().mockRejectedValue(new Error('redis down')),
    },
  } as unknown as RedisService;
  return new HealthController(prisma, redis);
}

describe('HealthController', () => {
  it('reports ok when database and redis respond', async () => {
    const result = await build(true, true).check();
    expect(result.status).toBe('ok');
    expect(result.database).toBe('up');
    expect(result.redis).toBe('up');
  });

  it('reports degraded when redis is down', async () => {
    const result = await build(true, false).check();
    expect(result.status).toBe('degraded');
    expect(result.redis).toBe('down');
  });

  it('reports degraded when database is down', async () => {
    const result = await build(false, true).check();
    expect(result.status).toBe('degraded');
    expect(result.database).toBe('down');
  });
});
