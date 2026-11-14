import { Module } from '@nestjs/common';
import { AdminTeamController, TeamController } from './team.controller.js';
import { AdminUsersController } from './users.controller.js';
import { TeamService } from './team.service.js';
import { UsersService } from './users.service.js';

/** User management: administrators' routes here, company employee status in CompanyController. */
@Module({
  controllers: [AdminUsersController, AdminTeamController, TeamController],
  providers: [UsersService, TeamService],
  exports: [UsersService],
})
export class UsersModule {}
