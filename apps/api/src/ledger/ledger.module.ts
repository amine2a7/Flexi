import { Global, Module } from '@nestjs/common';
import { LedgerService } from './ledger.service.js';

/** The single write path to the money, available to every financial module. */
@Global()
@Module({ providers: [LedgerService], exports: [LedgerService] })
export class LedgerModule {}
