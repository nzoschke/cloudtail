require "aws-sdk"

cursor = Time.now

cf  = Aws::CloudFormation::Client.new
ec2 = Aws::EC2::Client.new
elb = Aws::ElasticLoadBalancing::Client.new

def ecs_service_events
  ecs = Aws::ECS::Client.new

  events = []
  ecs.list_clusters.cluster_arns.each do |c_arn|
    service_arns = ecs.list_services(cluster: c_arn).service_arns

    next if service_arns.empty?

    ecs.describe_services(cluster: c_arn, services: service_arns).services.each do |service|
      events += service.events
    end
  end

  events
end

def cf_events
  cf = Aws::CloudFormation::Client.new

  events = []
  cf.describe_stacks.stacks.each do |stack|
    events += cf.describe_stack_events(stack_name: stack.stack_name).stack_events
  end

  events
end

@seen_event_ids = {}

def poll
  events = {}

  ecs_service_events.each do |e|
    if @seen_event_ids[e.id] == nil
      ts = e.created_at.to_i
      events[ts] ||= []
      events[ts] << "ts=#{e.created_at.to_i} id=#{e.id.split('-')[0]} msg=\"#{e.message}\"\n"
      @seen_event_ids[e.id] = 1
    end
  end

  cf_events.each do |e|
    if @seen_event_ids[e.event_id] == nil
      ts = e.timestamp.to_i
      events[ts] ||= []
      events[ts] << "ts=#{e.timestamp.to_i} id=#{e.event_id.split('-')[0]} msg=\"#{e.stack_name} #{e.resource_type} #{e.resource_status}\"\n"
      @seen_event_ids[e.event_id] = 1
    end
  end

  events.keys.sort.each do |k|
    events[k].each { |e| puts e }
  end

  sleep 5
  poll
end

poll