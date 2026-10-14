import { randomUUID } from 'node:crypto';
import { mkdir, readFile, writeFile } from 'node:fs/promises';
import { dirname, join, resolve, sep } from 'node:path';

/**
 * Storage of uploaded files (KYC pieces, transfer proofs). Local disk in development, behind this
 * interface so that a private cloud bucket can replace it without touching the services.
 */
export interface FileStorage {
  /** Stores the bytes and returns an opaque key (never a path chosen by the client). */
  put(data: Buffer): Promise<string>;
  get(key: string): Promise<Buffer>;
}

export const FILE_STORAGE = Symbol('FILE_STORAGE');

const KEY = /^[0-9]{4}\/[0-9]{2}\/[0-9a-f-]{36}$/;

/** Files under UPLOAD_DIR (ignored by Git), named by random UUID: no client-controlled path. */
export class LocalDiskStorage implements FileStorage {
  private readonly root: string;

  constructor(root: string) {
    this.root = resolve(root);
  }

  async put(data: Buffer): Promise<string> {
    const now = new Date();
    const key = `${String(now.getUTCFullYear())}/${String(now.getUTCMonth() + 1).padStart(2, '0')}/${randomUUID()}`;
    const path = this.pathOf(key);
    await mkdir(dirname(path), { recursive: true });
    await writeFile(path, data, { flag: 'wx' });
    return key;
  }

  async get(key: string): Promise<Buffer> {
    return readFile(this.pathOf(key));
  }

  private pathOf(key: string): string {
    if (!KEY.test(key)) throw new Error('invalid storage key');
    const path = resolve(join(this.root, ...key.split('/')));
    if (!path.startsWith(this.root + sep)) throw new Error('invalid storage key');
    return path;
  }
}
