# frozen_string_literal: true

require 'json'
require 'net/http'

class Nomad < Inspec.resource(1)
  name 'nomad'

  desc 'Resource to inspect the state of Nomad.'

  example '
    describe nomad do
      it { should be_healthy }
    end
  '

  def initialize(addr: ENV['NOMAD_ADDR'], token: ENV['NOMAD_TOKEN'])
    @token = token
    @addr  = addr || 'http://127.0.0.1:4646'
  end

  def members(**query_params)
    http_request('/v1/agent/members', query_params: query_params)
  end

  def servers(**query_params)
    http_request('/v1/agent/servers', query_params: query_params)
  end

  def self(**query_params)
    http_request('/v1/agent/self', query_params: query_params)
  end

  def health(**query_params)
    http_request('/v1/agent/health', query_params: query_params)
  end

  def healthy?
    status = health
    return status['client'] && status['server']
  end

  def host(**query_params)
    http_request('/v1/agent/host', query_params: query_params)
  end

  def jobs(**query_params)
    http_request('/v1/jobs', query_params: query_params)
  end

  def jobs?
    !jobs.empty?
  end

  def job(job_id, **query_params)
    http_request("/v1/job/#{job_id}", query_params: query_params)
  end

  def job_versions(job_id, **query_params)
    http_request("/v1/job/#{job_id}/versions", query_params: query_params)
  end

  def job_allocations(job_id, **query_params)
    http_request("/v1/job/#{job_id}/allocations", query_params: query_params)
  end

  def job_evaluations(job_id, **query_params)
    http_request("/v1/job/#{job_id}/evaluations", query_params: query_params)
  end

  def job_deployments(job_id, **query_params)
    http_request("/v1/job/#{job_id}/deployments", query_params: query_params)
  end

  def job_most_recent_deployment(job_id, **query_params)
    http_request("/v1/job/#{job_id}/deployment", query_params: query_params)
  end

  def job_summary(job_id, **query_params)
    http_request("/v1/job/#{job_id}/summary", query_params: query_params)
  end

  def job_scale_status(job_id, **query_params)
    http_request("/v1/job/#{job_id}/scale", query_params: query_params)
  end

  def acl_policies?
    !acl_policies.empty?
  rescue StandardError => e
    return false if e.message.include? 'Unexpected response code 500'

    raise e
  end

  def acl_policies(**query_params)
    http_request('/v1/acl/policies', query_params: query_params)
  end

  def acl_policy(policy_name, **query_params)
    http_request("/acl/policy/#{policy_name}", query_params: query_params)
  end

  def namespaces(**query_params)
    http_request('/v1/namespaces', query_params: query_params)
  end

  def namespace(namespace, **query_params)
    http_request("/v1/namespace/#{namespace}", query_params: query_params)
  end

  def nodes(**query_params)
    http_request('/v1/nodes', query_params: query_params)
  end

  def node(_node_id, **query_params)
    http_request("/v1/node/#{node_is}", query_params: query_params)
  end

  def metrics(**query_params)
    http_request("/v1/metrics/#{node_is}", query_params: query_params)
  end

  def raft_configuration(**query_params)
    http_request('/v1/operator/raft/configuration', query_params: query_params)
  end

  def autopilot_configuration(**query_params)
    http_request('/v1/operator/autopilot/configuration', query_params: query_params)
  end

  def autopilot_health(**query_params)
    http_request('/v1/operator/autopilot/health', query_params: query_params)
  end

  def scheduler_configuration(**query_params)
    http_request('/v1/operator/scheduler/configuration', query_params: query_params)
  end

  def enterprise_license(**query_params)
    http_request('/v1/operator/license', query_params: query_params)
  end

  def plugins(**query_params)
    http_request('/v1/plugins', query_params: query_params)
  end

  def csi_plugin(plugin_id, **query_params)
    http_request("/v1/plugin/csi/#{plugin_id}", query_params: query_params)
  end

  def quotas(**query_params)
    http_request('/v1/quotas', query_params: query_params)
  end

  def quota(quota, **query_params)
    http_request("/v1/quota/#{quota}", query_params: query_params)
  end

  def quota_usages(**query_params)
    http_request('/v1/quota-usages', query_params: query_params)
  end

  def quota_usage(quota, **query_params)
    http_request("/v1/quota/usage/#{quota}", query_params: query_params)
  end

  def regions(**query_params)
    http_request('/v1/regions', query_params: query_params)
  end

  def scaling_policies(**query_params)
    http_request('/v1/scaling/policies', query_params: query_params)
  end

  def search(prefix, context: 'all')
    body = JSON.encode({ "Prefix": prefix, "Context": context })
    http_request('/v1/search', verb: 'POST', body: body)
  end

  def sentinel_policies(**query_params)
    http_request('/v1/sentinel/policies', query_params: query_params)
  end

  def sentinel_policy(policy_name, **query_params)
    http_request("/v1/sentinel/policy/#{policy_name}", query_params: query_params)
  end

  def leader(**query_params)
    http_request('/v1/status/leader', query_params: query_params)
  end

  def peers(**query_params)
    http_request('/v1/status/peers', query_params: query_params)
  end

  def volumes(**query_params)
    http_request('/v1/volumes', query_params: query_params)
  end

  def csi_volume(volume_id, **query_params)
    http_request("/v1/volume/csi/#{volume_id}", query_params: query_params)
  end

  def evaluations(**query_params)
    http_request('/v1/evaluations', query_params: query_params)
  end

  def evaluation(eval_id, **query_params)
    http_request("/v1/evaluation/#{eval_id}", query_params: query_params)
  end

  def evaluation_allocations(eval_id, **query_params)
    http_request("/v1/evaluation/#{eval_id}/allocations", query_params: query_params)
  end

  def deployments(**query_params)
    http_request('/v1/deployments', query_params: query_params)
  end

  def deployment(deployment_id, **query_params)
    http_request("/v1/deployment/#{deployment_id}", query_params: query_params)
  end

  def client_stats(**query_params)
    http_request('/client/stats', query_params: query_params)
  end

  def client_alloc_stats(alloc_id, **query_params)
    http_request("/client/allocation/#{alloc_id}/stats", query_params: query_params)
  end

  def client_alloc_files(alloc_id, path, **query_params)
    query_params[:path] = path
    http_request("/client/fs/ls/#{alloc_id}", query_params: query_params)
  end

  def client_alloc_file_stat(alloc_id, path, **query_params)
    query_params[:path] = path
    http_request("/client/fs/stat/#{alloc_id}", query_params: query_params)
  end

  def client_alloc_file(alloc_id, path, **query_params)
    query_params[:path] = path
    http_request("/client/fs/cat/#{alloc_id}", query_params: query_params)
  end

  def client_alloc_file_at_offset(alloc_id, path, offset, limit, **query_params)
    query_params[:path] = path
    query_params[:offset] = offset
    query_params[:limit] = limit
    http_request("/client/fs/cat/#{alloc_id}", query_params: query_params)
  end

  def acl_tokens(**query_params)
    http_request('/v1/acl/tokens', query_params: query_params)
  end

  def acl_token(accessor_id, **query_params)
    http_request("/v1/acl/token/#{accessor_id}", query_params: query_params)
  end

  def acl_token_self(**query_params)
    http_request('/acl/token/self', query_params: query_params)
  end

  private

  def http_request(path, verb: 'GET', query_params: {}, body: nil, namespace: nil, expected_response_code: 200)
    uri = URI.parse(@addr + path)
    req = prepare_http_request(uri, verb: verb, query_params: query_params, body: body, namespace: namespace)
    req_options = {
      use_ssl: uri.scheme == 'https'
    }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(req)
    end

    handle_response(response, expected_response_code: expected_response_code)
  end

  def prepare_http_request(uri, verb: 'GET', query_params: {}, body: nil, namespace: nil)
    if verb == 'GET'
      request = Net::HTTP::Get.new(uri)
    elsif verb == 'POST'
      request = Net::HTTP::Post.new(uri)
    end
    request.body = bob unless body.nil?
    query_params = query_params.reject { |_, v| v.nil? }
    query_params[:namespace] = namespace unless namespace.nil?
    uri.query = URI.encode_www_form(query_params)
    request['X-Nomad-Token'] = @token unless @token.nil?
    request
  end

  def handle_response(response, expected_response_code: 200)
    unless response.code.to_i == expected_response_code.to_i
      raise("Error: Unexpected response code #{response.code} for #{path}")
    end

    if response.content_type == 'application/json'
      return JSON.parse(response.body)
    end

    response.body
  end
end
