// <copyright file="RulesController.cs" company="3M">
// Copyright (c) 3M. All rights reserved.
// </copyright>

using System.Collections.Generic;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Mmm.Iot.Common.Services.Exceptions;
using Mmm.Iot.Common.Services.Filters;
using Mmm.Iot.Common.Services.Models;
using Mmm.Iot.DeviceTelemetry.Services;
using Mmm.Iot.DeviceTelemetry.WebService.Models;

namespace Mmm.Iot.DeviceTelemetry.WebService.Controllers
{
    [Route("v1/[controller]")]
    [TypeFilter(typeof(ExceptionsFilterAttribute))]
    public sealed class RulesController : Controller
    {
        private readonly IRules ruleService;

        public RulesController(IRules ruleService)
        {
            this.ruleService = ruleService;
        }

        [HttpGet("{id}")]
        [Authorize("ReadAll")]
        public async Task<RuleApiModel> GetAsync([FromRoute] string id)
        {
            Rule rule = await this.ruleService.GetAsync(id);
            return new RuleApiModel(rule, rule.Deleted);
        }

        [HttpGet]
        [Authorize("ReadAll")]
        public async Task<RuleListApiModel> ListAsync(
            [FromQuery] string order,
            [FromQuery] int? skip,
            [FromQuery] int? limit,
            [FromQuery] string groupId,
            [FromQuery] bool? includeDeleted)
        {
            if (order == null)
            {
                order = "asc";
            }

            if (skip == null)
            {
                skip = 0;
            }

            if (limit == null)
            {
                limit = 1000;
            }

            if (includeDeleted == null)
            {
                includeDeleted = false;
            }

            List<Rule> rules = await this.ruleService.GetListAsync(
                    order,
                    skip.Value,
                    limit.Value,
                    groupId,
                    includeDeleted.Value);
            Dictionary<string, string> lastTriggeredValues = await this.ruleService.GetLastTriggerForRules(rules);
            return new RuleListApiModel(
                rules,
                includeDeleted.Value,
                lastTriggeredValues);
        }

        [HttpPost]
        [Authorize("CreateRules")]
        public async Task<RuleApiModel> PostAsync(
            [FromQuery] string template,
            [FromBody] RuleApiModel rule)
        {
            if (!string.IsNullOrEmpty(template))
            {
                // create rules from template
                await this.ruleService.CreateFromTemplateAsync(template);
                return null;
            }

            // create rule from request body
            if (rule == null)
            {
                throw new InvalidInputException("Rule not provided in request body.");
            }

            Rule newRule = await this.ruleService.CreateAsync(rule.ToServiceModel());

            return new RuleApiModel(newRule, false);
        }

        [HttpPut("{id}")]
        [Authorize("UpdateRules")]
        public async Task<RuleApiModel> PutAsync(
            [FromRoute] string id,
            [FromBody] RuleApiModel rule)
        {
            if (rule == null)
            {
                throw new InvalidInputException("Rule not provided in request body.");
            }

            // Ensure the id on the model matches the route
            rule.Id = id;
            Rule updatedRule = await this.ruleService.UpsertIfNotDeletedAsync(rule.ToServiceModel());

            return new RuleApiModel(updatedRule, false);
        }

        [HttpDelete("{id}")]
        [Authorize("DeleteRules")]
        public async Task DeleteAsync([FromRoute] string id)
        {
            await this.ruleService.DeleteAsync(id);
        }
    }
}