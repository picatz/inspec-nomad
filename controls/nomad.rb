title 'Nomad Secure Configuration'

control 'nomad-1.1' do
  impact 1.0
  title 'Must be healthy'
  desc 'Example control'

  ref 'Nomad Security Model', url: 'https://www.nomadproject.io/docs/internals/security'

  describe nomad do
    it { should be_healthy }
  end
end