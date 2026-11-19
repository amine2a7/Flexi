import { Controller, Get, Inject, Query } from '@nestjs/common';
import { z } from 'zod';
import { Can, Roles } from '../common/decorators.js';
import { parse } from '../common/validation.js';
import { SearchService } from './search.service.js';

/** Global search of the web header (W-SUP): 2 characters at least, limited per address. */
@Roles('ADMIN', 'COMPANY', 'MERCHANT')
@Controller('v1/search')
export class SearchController {
  constructor(@Inject(SearchService) private readonly searchService: SearchService) {}

  @Can('search.use', 'adminSearch.read')
  @Get()
  search(@Query() query: Record<string, unknown>) {
    const { q } = parse(
      z.object({ q: z.string().trim().min(2).max(100) }),
      { q: query.q },
      'query',
    );
    return this.searchService.search(q);
  }
}
