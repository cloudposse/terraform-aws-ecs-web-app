package test

import (
	"encoding/json"
	"testing"

	"math/rand"
	"strconv"
	"time"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

// Test the Terraform module in examples/complete using Terratest.
func TestExamplesComplete(t *testing.T) {
	t.Parallel()

	rand.Seed(time.Now().UnixNano())

	attributes := []string{strconv.Itoa(rand.Intn(1000))}

	// We need to create the ALB first because terraform does not wwait for it to be in the ready state before creating ECS target group
	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../../examples/complete",
		Upgrade:      true,
		// Variables to pass to our Terraform code using -var-file options
		VarFiles: []string{"fixtures.us-east-2.tfvars"},
		Vars: map[string]interface{}{
			"attributes": attributes,
		},
		Targets: []string{"module.this", "module.vpc", "module.subnets", "module.alb"},
	}

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)

	terraformOptions.Targets = nil

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.Apply(t, terraformOptions)

	// Run `terraform output` to get the value of an output variable
	vpcCidr := terraform.Output(t, terraformOptions, "vpc_cidr")
	// Verify we're getting back the outputs we expect
	assert.Equal(t, "172.16.0.0/16", vpcCidr)

	// Run `terraform output` to get the value of an output variable
	privateSubnetCidrs := terraform.OutputList(t, terraformOptions, "private_subnet_cidrs")
	// Verify we're getting back the outputs we expect
	assert.Equal(t, []string{"172.16.0.0/19", "172.16.32.0/19"}, privateSubnetCidrs)

	// Run `terraform output` to get the value of an output variable
	publicSubnetCidrs := terraform.OutputList(t, terraformOptions, "public_subnet_cidrs")
	// Verify we're getting back the outputs we expect
	assert.Equal(t, []string{"172.16.96.0/19", "172.16.128.0/19"}, publicSubnetCidrs)

	// Run `terraform output` to get the value of an output variable
	albName := terraform.Output(t, terraformOptions, "alb_name")
	// Verify we're getting back the outputs we expect
	expectedalbName := "eg-test-ecs-web-app-" + attributes[0]
	assert.Equal(t, expectedalbName, albName)

	// Run `terraform output` to get the value of an output variable
	albHttpListenerArn := terraform.Output(t, terraformOptions, "alb_http_listener_arn")
	// Verify we're getting back the outputs we expect
	assert.Contains(t, albHttpListenerArn, "listener/app/eg-test-ecs-web-app")

	// Run `terraform output` to get the value of an output variable
	albIngressTargetGroupName := terraform.Output(t, terraformOptions, "alb_ingress_target_group_name")
	// Verify we're getting back the outputs we expect
	expectedAlbIngressTargetGroupName := "eg-test-ecs-web-app-" + attributes[0]
	assert.Equal(t, expectedAlbIngressTargetGroupName, albIngressTargetGroupName)

	// Run `terraform output` to get the value of an output variable
	albAccessLogsBucketId := terraform.Output(t, terraformOptions, "alb_access_logs_bucket_id")
	// Verify we're getting back the outputs we expect
	expectedAlbAccessLogsBucketId := "eg-test-ecs-web-app-" + attributes[0] + "-alb-access-logs"
	assert.Equal(t, expectedAlbAccessLogsBucketId, albAccessLogsBucketId)

	// Run `terraform output` to get the value of an output variable
	containerDefinitionJsonMap := terraform.OutputRequired(t, terraformOptions, "container_definition_json_map")
	// Verify we're getting back the outputs we expect
	var jsonObject map[string]interface{}
	err := json.Unmarshal([]byte(containerDefinitionJsonMap), &jsonObject)
	assert.NoError(t, err)
	expectedContainerDefinitionName := "eg-test-ecs-web-app-" + attributes[0]
	assert.Equal(t, expectedContainerDefinitionName, jsonObject["name"])
	assert.Equal(t, "cloudposse/default-backend", jsonObject["image"])
	assert.Equal(t, 512, int((jsonObject["memory"]).(float64)))
	assert.Equal(t, 128, int((jsonObject["memoryReservation"]).(float64)))
	assert.Equal(t, 256, int((jsonObject["cpu"]).(float64)))
	assert.Equal(t, true, jsonObject["essential"])
	assert.Equal(t, false, jsonObject["readonlyRootFilesystem"])

	// Run `terraform output` to get the value of an output variable
	codebuildCacheBucketName := terraform.Output(t, terraformOptions, "codebuild_cache_bucket_name")
	// Verify we're getting back the outputs we expect
	expectedCodebuildCacheBucketName := "eg-test-ecs-web-app-" + attributes[0] + "-build"
	assert.Contains(t, codebuildCacheBucketName, expectedCodebuildCacheBucketName)

	// Run `terraform output` to get the value of an output variable
	codebuildProjectName := terraform.Output(t, terraformOptions, "codebuild_project_name")
	// Verify we're getting back the outputs we expect
	expectedCodebuildProjectName := "eg-test-ecs-web-app-" + attributes[0] + "-build"
	assert.Equal(t, expectedCodebuildProjectName, codebuildProjectName)

	// Run `terraform output` to get the value of an output variable
	codebuildRoleId := terraform.Output(t, terraformOptions, "codebuild_role_id")
	// Verify we're getting back the outputs we expect
	expectedCodebuildRoleId := "eg-test-ecs-web-app-" + attributes[0] + "-build"
	assert.Equal(t, expectedCodebuildRoleId, codebuildRoleId)

	// Run `terraform output` to get the value of an output variable
	codepipelineId := terraform.Output(t, terraformOptions, "codepipeline_id")
	// Verify we're getting back the outputs we expect
	expectedCodepipelineId := "eg-test-ecs-web-app-" + attributes[0] + "-codepipeline"
	assert.Equal(t, expectedCodepipelineId, codepipelineId)

	// Run `terraform output` to get the value of an output variable
	ecrRepositoryName := terraform.Output(t, terraformOptions, "ecr_repository_name")
	// Verify we're getting back the outputs we expect
	expectedEcrRepositoryName := "eg-test-ecs-web-app-" + attributes[0] + "-ecr"
	assert.Equal(t, expectedEcrRepositoryName, ecrRepositoryName)

	// Run `terraform output` to get the value of an output variable
	ecsTaskRoleName := terraform.Output(t, terraformOptions, "ecs_task_role_name")
	// Verify we're getting back the outputs we expect
	expectedEcsTaskRoleName := "eg-test-ecs-web-app-" + attributes[0] + "-task"
	assert.Equal(t, expectedEcsTaskRoleName, ecsTaskRoleName)

	// Run `terraform output` to get the value of an output variable
	ecsTaskExecRoleName := terraform.Output(t, terraformOptions, "ecs_task_exec_role_name")
	// Verify we're getting back the outputs we expect
	expectedEcsTaskExecRoleName := "eg-test-ecs-web-app-" + attributes[0] + "-exec"
	assert.Equal(t, expectedEcsTaskExecRoleName, ecsTaskExecRoleName)

	// Run `terraform output` to get the value of an output variable
	ecsServiceName := terraform.Output(t, terraformOptions, "ecs_service_name")
	// Verify we're getting back the outputs we expect
	expectedEcsServiceName := "eg-test-ecs-web-app-" + attributes[0]
	assert.Equal(t, expectedEcsServiceName, ecsServiceName)

	// Run `terraform output` to get the value of an output variable
	ecsExecRolePolicyName := terraform.Output(t, terraformOptions, "ecs_exec_role_policy_name")
	// Verify we're getting back the outputs we expect
	expectedEcsExecRolePolicyName := "eg-test-ecs-web-app-" + attributes[0] + "-exec"
	assert.Equal(t, expectedEcsExecRolePolicyName, ecsExecRolePolicyName)

	// Run `terraform output` to get the value of an output variable
	ecsCloudwatchAutoscalingScaleDownPolicyArn := terraform.Output(t, terraformOptions, "ecs_cloudwatch_autoscaling_scale_down_policy_arn")
	// Verify we're getting back the outputs we expect
	expectedEcsCloudwatchAutoscalingScaleDownPolicyArn := "policyName/down"
	assert.Contains(t, ecsCloudwatchAutoscalingScaleDownPolicyArn, expectedEcsCloudwatchAutoscalingScaleDownPolicyArn)

	// Run `terraform output` to get the value of an output variable
	ecsCloudwatchAutoscalingScaleUpPolicyArn := terraform.Output(t, terraformOptions, "ecs_cloudwatch_autoscaling_scale_up_policy_arn")
	// Verify we're getting back the outputs we expect
	expectedEcsCloudwatchAutoscalingScaleUpPolicyArn := "policyName/up"
	assert.Contains(t, ecsCloudwatchAutoscalingScaleUpPolicyArn, expectedEcsCloudwatchAutoscalingScaleUpPolicyArn)

	// Run `terraform output` to get the value of an output variable
	ecsAlarmsCpuUtilizationHighCloudwatchMetricAlarmId := terraform.Output(t, terraformOptions, "ecs_alarms_cpu_utilization_high_cloudwatch_metric_alarm_id")
	// Verify we're getting back the outputs we expect
	expectedEcsAlarmsCpuUtilizationHighCloudwatchMetricAlarmId := "eg-test-ecs-web-app-" + attributes[0] + "-cpu-utilization-high"
	assert.Equal(t, expectedEcsAlarmsCpuUtilizationHighCloudwatchMetricAlarmId, ecsAlarmsCpuUtilizationHighCloudwatchMetricAlarmId)

	// Run `terraform output` to get the value of an output variable
	ecsAlarmsCpuUtilizationLowCloudwatchMetricAlarmId := terraform.Output(t, terraformOptions, "ecs_alarms_cpu_utilization_low_cloudwatch_metric_alarm_id")
	// Verify we're getting back the outputs we expect
	expectedEcsAlarmsCpuUtilizationLowCloudwatchMetricAlarmId := "eg-test-ecs-web-app-" + attributes[0] + "-cpu-utilization-low"
	assert.Equal(t, expectedEcsAlarmsCpuUtilizationLowCloudwatchMetricAlarmId, ecsAlarmsCpuUtilizationLowCloudwatchMetricAlarmId)

	// Run `terraform output` to get the value of an output variable
	ecsAlarmsMemoryUtilizationHighCloudwatchMetricAlarmId := terraform.Output(t, terraformOptions, "ecs_alarms_memory_utilization_high_cloudwatch_metric_alarm_id")
	// Verify we're getting back the outputs we expect
	expectedEcsAlarmsMemoryUtilizationHighCloudwatchMetricAlarmId := "eg-test-ecs-web-app-" + attributes[0] + "-memory-utilization-high"
	assert.Equal(t, expectedEcsAlarmsMemoryUtilizationHighCloudwatchMetricAlarmId, ecsAlarmsMemoryUtilizationHighCloudwatchMetricAlarmId)

	// Run `terraform output` to get the value of an output variable
	ecsAlarmsMemoryUtilizationLowCloudwatchMetricAlarmId := terraform.Output(t, terraformOptions, "ecs_alarms_memory_utilization_low_cloudwatch_metric_alarm_id")
	// Verify we're getting back the outputs we expect
	expectedEcsAlarmsMemoryUtilizationLowCloudwatchMetricAlarmId := "eg-test-ecs-web-app-" + attributes[0] + "-memory-utilization-low"
	assert.Equal(t, expectedEcsAlarmsMemoryUtilizationLowCloudwatchMetricAlarmId, ecsAlarmsMemoryUtilizationLowCloudwatchMetricAlarmId)

	// Run `terraform output` to get the value of an output variable
	httpcodeElb5xxCountCloudwatchMetricAlarmId := terraform.Output(t, terraformOptions, "httpcode_elb_5xx_count_cloudwatch_metric_alarm_id")
	// Verify we're getting back the outputs we expect
	expectedHttpcodeElb5xxCountCloudwatchMetricAlarmId := "eg-test-ecs-web-app-" + attributes[0] + "-elb-5xx-count-high"
	assert.Equal(t, expectedHttpcodeElb5xxCountCloudwatchMetricAlarmId, httpcodeElb5xxCountCloudwatchMetricAlarmId)

	// Run `terraform output` to get the value of an output variable
	httpcodeTarget3xxCountCloudwatchMetricAlarmId := terraform.Output(t, terraformOptions, "httpcode_target_3xx_count_cloudwatch_metric_alarm_id")
	// Verify we're getting back the outputs we expect
	expectedHttpcodeTarget3xxCountCloudwatchMetricAlarmId := "eg-test-ecs-web-app-" + attributes[0] + "-3xx-count-high"
	assert.Equal(t, expectedHttpcodeTarget3xxCountCloudwatchMetricAlarmId, httpcodeTarget3xxCountCloudwatchMetricAlarmId)

	// Run `terraform output` to get the value of an output variable
	httpcodeTarget4xxCountCloudwatchMetricAlarmId := terraform.Output(t, terraformOptions, "httpcode_target_4xx_count_cloudwatch_metric_alarm_id")
	// Verify we're getting back the outputs we expect
	expectedHttpcodeTarget4xxCountCloudwatchMetricAlarmId := "eg-test-ecs-web-app-" + attributes[0] + "-4xx-count-high"
	assert.Equal(t, expectedHttpcodeTarget4xxCountCloudwatchMetricAlarmId, httpcodeTarget4xxCountCloudwatchMetricAlarmId)

	// Run `terraform output` to get the value of an output variable
	httpcodeTarget5xxCountCloudwatchMetricAlarmId := terraform.Output(t, terraformOptions, "httpcode_target_5xx_count_cloudwatch_metric_alarm_id")
	// Verify we're getting back the outputs we expect
	expectedHttpcodeTarget5xxCountCloudwatchMetricAlarmId := "eg-test-ecs-web-app-" + attributes[0] + "-5xx-count-high"
	assert.Equal(t, expectedHttpcodeTarget5xxCountCloudwatchMetricAlarmId, httpcodeTarget5xxCountCloudwatchMetricAlarmId)

	// Run `terraform output` to get the value of an output variable
	targetResponseTimeAverageCloudwatchMetricAlarmId := terraform.Output(t, terraformOptions, "target_response_time_average_cloudwatch_metric_alarm_id")
	// Verify we're getting back the outputs we
	expectedTargetResponseTimeAverageCloudwatchMetricAlarmId := "eg-test-ecs-web-app-" + attributes[0] + "-target-response-high"
	assert.Equal(t, expectedTargetResponseTimeAverageCloudwatchMetricAlarmId, targetResponseTimeAverageCloudwatchMetricAlarmId)
}
