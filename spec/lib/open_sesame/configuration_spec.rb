require 'spec_helper'

describe OpenSesame::Configuration do

  let(:configuration) { OpenSesame::Configuration.new }
  subject { configuration }

  it "organization sets organzation name" do
    configuration.organization "challengepost"
    configuration.organization_name.should == "challengepost"
  end

  it "github sets github client credentials" do
    configuration.github "client_id", "client_secret"
    configuration.github_application[:client_id].should == "client_id"
    configuration.github_application[:client_secret].should == "client_secret"
  end

  it "github sets github token credentials" do
    configuration.github_access_token "access_token"
    configuration.github_application[:access_token].should == "access_token"
  end

  it "mounted_at sets mount_prefix" do
    configuration.mounted_at "/foobar"
    configuration.mount_prefix.should == "/foobar"
  end

  it "auto_access sets provider to attempt auto login" do
    configuration.auto_login "github"
    configuration.auto_access_provider.should == "github"
  end

  it "sets all redirects to" do
    configuration.redirect_to "/foobar"
    configuration.after_login_path.should == "/foobar"
    configuration.after_logout_path.should == "/foobar"
  end

  it "sets after_login path" do
    configuration.redirect_after_login "/foobar"
    configuration.after_login_path.should == "/foobar"
  end

  it "sets after_logout redirect_to" do
    configuration.redirect_after_logout "/foobar"
    configuration.after_logout_path.should == "/foobar"
  end

  describe "valid?" do
    it "false when values not set" do
      configuration.organization "challengepost"
      configuration.should_not be_valid

      configuration.organization_name = nil
      configuration.github "client_id", "client_secret"
      configuration.should_not be_valid

      configuration.github_application = nil
      configuration.mounted_at "/foobar"
      configuration.should_not be_valid
    end

    it "true when all values set" do
      configuration.organization "challengepost"
      configuration.github "client_id", "client_secret"
      configuration.mounted_at "/foobar"
      configuration.should be_valid
    end
  end

  describe "validate!" do
    it { lambda { configuration.validate! }.should raise_error(OpenSesame::ConfigurationError) }

    it "succeeds when valid" do
      configuration.organization "challengepost"
      configuration.github "client_id", "client_secret"
      configuration.mounted_at "/foobar"
      configuration.should be_valid

      configuration.validate!.should be_true
    end
  end

  describe "enabled?" do

    it { configuration.enabled?.should be_false }

    it "true if enabled!" do
      configuration.enable!
      configuration.should be_enabled
    end

    it "false if disabled" do
      configuration.disable!
      configuration.should_not be_enabled
    end

  end
end
