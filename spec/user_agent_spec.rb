require 'user_agent'
require 'ostruct'

describe UserAgent do
  it "should require a product" do
    lambda { UserAgent.new(nil) }.should raise_error(ArgumentError, "expected a value for product")
  end

  it "should split comment to an array if a string is passed in" do
    useragent = UserAgent.new("Mozilla", "5.0", "Macintosh; U; Intel Mac OS X 10_5_3; en-us")
    useragent.comment.should == ["Macintosh", "U", "Intel Mac OS X 10_5_3", "en-us"]
  end

  it "should set version to nil if it is blank" do
    UserAgent.new("Mozilla", "").version.should be_nil
  end

  it "should only output product when coerced to a string" do
    UserAgent.new("Mozilla").to_str.should == "Mozilla"
  end

  it "should output product and version when coerced to a string" do
    UserAgent.new("Mozilla", "5.0").to_str.should == "Mozilla/5.0"
  end

  it "should output product, version and comment when coerced to a string" do
    useragent = UserAgent.new("Mozilla", "5.0", ["Macintosh", "U", "Intel Mac OS X 10_5_3", "en-us"])
    useragent.to_str.should == "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_5_3; en-us)"
  end

  it "should output product and comment when coerced to a string" do
    useragent = UserAgent.new("Mozilla", nil, ["Macintosh"])
    useragent.to_str.should == "Mozilla (Macintosh)"
  end

  it "should be eql if both products are the same" do
    UserAgent.new("Mozilla").should eql(UserAgent.new("Mozilla"))
  end

  it "should not be eql if both products are the same" do
    UserAgent.new("Mozilla").should_not eql(UserAgent.new("Opera"))
  end

  it "should be eql if both products and versions are the same" do
    UserAgent.new("Mozilla", "5.0").should eql(UserAgent.new("Mozilla", "5.0"))
  end

  it "should not be eql if both products and versions are not the same" do
    UserAgent.new("Mozilla", "5.0").should_not eql(UserAgent.new("Mozilla", "4.0"))
  end

  it "should be eql if both products, versions and comments are the same" do
    UserAgent.new("Mozilla", "5.0", ["Macintosh"]).should eql(UserAgent.new("Mozilla", "5.0", ["Macintosh"]))
  end

  it "should not be eql if both products, versions and comments are not the same" do
    UserAgent.new("Mozilla", "5.0", ["Macintosh"]).should_not eql(UserAgent.new("Mozilla", "5.0", ["Windows"]))
  end

  it "should not be eql if both products, versions and comments are not the same" do
    UserAgent.new("Mozilla", "5.0", ["Macintosh"]).should_not eql(UserAgent.new("Mozilla", "4.0", ["Macintosh"]))
  end

  it "should not be equal? if both products are the same" do
    UserAgent.new("Mozilla").should_not equal(UserAgent.new("Mozilla"))
  end

  it "should be == if products are the same" do
    UserAgent.new("Mozilla").should == UserAgent.new("Mozilla")
  end

  it "should be == if products and versions are the same" do
    UserAgent.new("Mozilla", "5.0").should == UserAgent.new("Mozilla", "5.0")
  end

  it "should not be == if products and versions are the different" do
    UserAgent.new("Mozilla", "5.0").should_not == UserAgent.new("Mozilla", "4.0")
  end

  it "should return false if comparing different products" do
    UserAgent.new("Mozilla").should_not <= UserAgent.new("Opera")
  end

  it "should not be > if products are the same" do
    UserAgent.new("Mozilla").should_not > UserAgent.new("Mozilla")
  end

  it "should not be < if products are the same" do
    UserAgent.new("Mozilla").should_not < UserAgent.new("Mozilla")
  end

  it "should be >= if products are the same" do
    UserAgent.new("Mozilla").should >= UserAgent.new("Mozilla")
  end

  it "should be <= if products are the same" do
    UserAgent.new("Mozilla").should <= UserAgent.new("Mozilla")
  end

  it "should be > if products are the same and version is greater" do
    UserAgent.new("Mozilla", "5.0").should > UserAgent.new("Mozilla", "4.0")
  end

  it "should not be > if products are the same and version is less" do
    UserAgent.new("Mozilla", "4.0").should_not > UserAgent.new("Mozilla", "5.0")
  end

  it "should be < if products are the same and version is less" do
    UserAgent.new("Mozilla", "4.0").should < UserAgent.new("Mozilla", "5.0")
  end

  it "should not be < if products are the same and version is greater" do
    UserAgent.new("Mozilla", "5.0").should_not < UserAgent.new("Mozilla", "4.0")
  end

  it "should be >= if products are the same and version is greater" do
    UserAgent.new("Mozilla", "5.0").should >= UserAgent.new("Mozilla", "4.0")
  end

  it "should not be >= if products are the same and version is less" do
    UserAgent.new("Mozilla", "4.0").should_not >= UserAgent.new("Mozilla", "5.0")
  end

  it "should be <= if products are the same and version is less" do
    UserAgent.new("Mozilla", "4.0").should <= UserAgent.new("Mozilla", "5.0")
  end

  it "should not be <= if products are the same and version is greater" do
    UserAgent.new("Mozilla", "5.0").should_not <= UserAgent.new("Mozilla", "4.0")
  end

  it "should be >= if products are the same and version is the same" do
    UserAgent.new("Mozilla", "5.0").should >= UserAgent.new("Mozilla", "5.0")
  end

  it "should be <= if products are the same and version is the same" do
    UserAgent.new("Mozilla", "5.0").should <= UserAgent.new("Mozilla", "5.0")
  end
end

describe UserAgent, "::MATCHER" do
  it "should not match a blank line" do
    UserAgent::MATCHER.should_not =~ ""
  end

  it "should match a single product" do
    UserAgent::MATCHER.should =~ "Mozilla"
  end

  it "should match a product and version" do
    UserAgent::MATCHER.should =~ "Mozilla/5.0"
  end

  it "should match a product, version, and comment" do
    UserAgent::MATCHER.should =~ "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_5_3; en-us)"
  end

  it "should match a product, and comment" do
    UserAgent::MATCHER.should =~ "Mozilla (Macintosh; U; Intel Mac OS X 10_5_3; en-us)"
  end
end

describe UserAgent, ".parse" do
  it "should concatenate user agents when coerced to a string" do
    string = UserAgent.parse("Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_5_3; en-us) AppleWebKit/525.18 (KHTML, like Gecko) Version/3.1.1 Safari/525.18")
    string.to_str.should == "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_5_3; en-us) AppleWebKit/525.18 (KHTML, like Gecko) Version/3.1.1 Safari/525.18"
  end

  it "should parse a single product" do
    useragent = UserAgent.new("Mozilla")
    UserAgent.parse("Mozilla").application.should == useragent
  end

  it "should parse a single product with version" do
    useragent = UserAgent.new("Mozilla", "5.0")
    UserAgent.parse("Mozilla/5.0").application.should == useragent
  end

  it "should parse a single product, version, and comment" do
    useragent = UserAgent.new("Mozilla", "5.0", ["Macintosh", "U", "Intel Mac OS X 10_5_3", "en-us"])
    UserAgent.parse("Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_5_3; en-us)").application.should == useragent
  end

  it "should parse a single product, version, and comment, with space-padded semicolons" do
    useragent = UserAgent.new("Mozilla", "5.0", ["Macintosh", "U", "Intel Mac OS X 10_5_3", "en-us"])
    UserAgent.parse("Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_5_3 ; en-us; )").application.should == useragent
  end

  it "should parse a single product and comment" do
    useragent = UserAgent.new("Mozilla", nil, ["Macintosh"])
    UserAgent.parse("Mozilla (Macintosh)").application.should == useragent
  end
end

describe UserAgent::Browsers::All, "#<" do
  before do
    @ie_7 = UserAgent.parse("Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.0)")
    @ie_6 = UserAgent.parse("Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1)")
    @firefox = UserAgent.parse("Mozilla/5.0 (Macintosh; U; Intel Mac OS X; en-US; rv:1.8.1.14) Gecko/20080404 Firefox/2.0.0.14")
  end

  it "should not be < if user agent does not have a browser" do
    @ie_7.should_not < "Mozilla"
  end

  it "should not be < if user agent does not have the same browser" do
    @ie_7.should_not < @firefox
  end

  it "should be < if version is less than its version" do
    @ie_6.should < @ie_7
  end

  it "should not be < if version is the same as its version" do
    @ie_6.should_not < @ie_6
  end

  it "should not be < if version is greater than its version" do
    @ie_7.should_not < @ie_6
  end
end

describe UserAgent::Browsers::All, "#<=" do
  before do
    @ie_7 = UserAgent.parse("Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.0)")
    @ie_6 = UserAgent.parse("Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1)")
    @firefox = UserAgent.parse("Mozilla/5.0 (Macintosh; U; Intel Mac OS X; en-US; rv:1.8.1.14) Gecko/20080404 Firefox/2.0.0.14")
  end

  it "should not be <= if user agent does not have a browser" do
    @ie_7.should_not <= "Mozilla"
  end

  it "should not be <= if user agent does not have the same browser" do
    @ie_7.should_not <= @firefox
  end

  it "should be <= if version is less than its version" do
    @ie_6.should <= @ie_7
  end

  it "should be <= if version is the same as its version" do
    @ie_6.should <= @ie_6
  end

  it "should not be <= if version is greater than its version" do
    @ie_7.should_not <= @ie_6
  end
end

describe UserAgent::Browsers::All, "#==" do
  before do
    @ie_7 = UserAgent.parse("Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.0)")
    @ie_6 = UserAgent.parse("Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1)")
    @firefox = UserAgent.parse("Mozilla/5.0 (Macintosh; U; Intel Mac OS X; en-US; rv:1.8.1.14) Gecko/20080404 Firefox/2.0.0.14")
  end

  it "should not be == if user agent does not have a browser" do
    @ie_7.should_not == "Mozilla"
  end

  it "should not be == if user agent does not have the same browser" do
    @ie_7.should_not == @firefox
  end

  it "should not be == if version is less than its version" do
    @ie_6.should_not == @ie_7
  end

  it "should be == if version is the same as its version" do
    @ie_6.should == @ie_6
  end

  it "should not be == if version is greater than its version" do
    @ie_7.should_not == @ie_6
  end
end

describe UserAgent::Browsers::All, "#>" do
  before do
    @ie_7 = UserAgent.parse("Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.0)")
    @ie_6 = UserAgent.parse("Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1)")
    @firefox = UserAgent.parse("Mozilla/5.0 (Macintosh; U; Intel Mac OS X; en-US; rv:1.8.1.14) Gecko/20080404 Firefox/2.0.0.14")
  end

  it "should not be > if user agent does not have a browser" do
    @ie_7.should_not > "Mozilla"
  end

  it "should not be > if user agent does not have the same browser" do
    @ie_7.should_not > @firefox
  end

  it "should not be > if version is less than its version" do
    @ie_6.should_not > @ie_7
  end

  it "should not be > if version is the same as its version" do
    @ie_6.should_not > @ie_6
  end

  it "should be > if version is greater than its version" do
    @ie_7.should > @ie_6
  end
end

describe UserAgent::Browsers::All, "#>=" do
  before do
    @ie_7 = UserAgent.parse("Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.0)")
    @ie_6 = UserAgent.parse("Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1)")
    @firefox = UserAgent.parse("Mozilla/5.0 (Macintosh; U; Intel Mac OS X; en-US; rv:1.8.1.14) Gecko/20080404 Firefox/2.0.0.14")
  end

  it "should not be >= if user agent does not have a browser" do
    @ie_7.should_not >= "Mozilla"
  end

  it "should not be >= if user agent does not have the same browser" do
    @ie_7.should_not >= @firefox
  end

  it "should not be >= if version is less than its version" do
    @ie_6.should_not >= @ie_7
  end

  it "should be >= if version is the same as its version" do
    @ie_6.should >= @ie_6
  end

  it "should be >= if version is greater than its version" do
    @ie_7.should >= @ie_6
  end
end

describe UserAgent::Version do
  it "should be eql if versions are the same" do
    UserAgent::Version.new("5.0").should eql(UserAgent::Version.new("5.0"))
  end

  it "should not be eql if versions are the different" do
    UserAgent::Version.new("9.0").should_not eql(UserAgent::Version.new("5.0"))
  end

  it "should be == if versions are the same" do
    UserAgent::Version.new("5.0").should == UserAgent::Version.new("5.0")
  end

  it "should be == if versions are the same string" do
    UserAgent::Version.new("5.0").should == "5.0"
  end

  it "should not be == if versions are the different" do
    UserAgent::Version.new("9.0").should_not == UserAgent::Version.new("5.0")
  end

  it "should not be == to nil" do
    UserAgent::Version.new("9.0").should_not == nil
  end

  it "should not be == to []" do
    UserAgent::Version.new("9.0").should_not == []
  end

  it "should be < if version is less" do
    UserAgent::Version.new("9.0").should < UserAgent::Version.new("10.0")
  end

  it "should be < if version is less" do
    UserAgent::Version.new("4").should < UserAgent::Version.new("4.1")
  end

  it "should be < if version is less and a string" do
    UserAgent::Version.new("9.0").should < "10.0"
  end

  it "should not be < if version is greater" do
    UserAgent::Version.new("9.0").should_not > UserAgent::Version.new("10.0")
  end

  it "should be <= if version is less" do
    UserAgent::Version.new("9.0").should <= UserAgent::Version.new("10.0")
  end

  it "should not be <= if version is greater" do
    UserAgent::Version.new("9.0").should_not >= UserAgent::Version.new("10.0")
  end

  it "should be <= if version is same" do
    UserAgent::Version.new("9.0").should <= UserAgent::Version.new("9.0")
  end

  it "should be > if version is greater" do
    UserAgent::Version.new("1.0").should > UserAgent::Version.new("0.9")
  end

  it "should be > if version is greater" do
    UserAgent::Version.new("4.1").should > UserAgent::Version.new("4")
  end

  it "should not be > if version is less" do
    UserAgent::Version.new("0.0.1").should_not > UserAgent::Version.new("10.0")
  end

  it "should be >= if version is greater" do
    UserAgent::Version.new("10.0").should >= UserAgent::Version.new("4.0")
  end

  it "should not be >= if version is less" do
    UserAgent::Version.new("0.9").should_not >= UserAgent::Version.new("1.0")
  end

  it "should not be > if version is invalid" do
    UserAgent::Version.new("x.x").should_not > UserAgent::Version.new("1.0")
  end

  it "should be < if version is invalid" do
    UserAgent::Version.new("x.x").should < UserAgent::Version.new("1.0")
  end

  it "should be > when compared with invalid" do
    UserAgent::Version.new("1.0").should > UserAgent::Version.new("x.x")
  end

  it "should not be < when compared with invalid" do
    UserAgent::Version.new("1.0").should_not < UserAgent::Version.new("x.x")
  end

  it "should not be > if both versions are invalid" do
    UserAgent::Version.new("a.a").should_not > UserAgent::Version.new("b.b")
  end

  it "should be < if both versions are invalid" do
    UserAgent::Version.new("a.a").should < UserAgent::Version.new("b.b")
  end

  it "should raise ArgumentError if other is nil" do
    lambda { UserAgent::Version.new("9.0").should < nil }.should raise_error(ArgumentError, "comparison of UserAgent::Version with nil failed")
  end

  context "comparing with structs" do
    it "should not be < if products are the same and version is greater" do
      UserAgent.parse("Mozilla/5.0 (compatible; MSIE 10.0; Windows NT 6.2; WOW64; Trident/6.0)").should_not < OpenStruct.new(:browser => "Internet Explorer", :version => "7.0")
    end
  end
end


describe UserAgent::Browsers::All, "#mobile?" do
  before do
    @ie_7 = UserAgent.parse("Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.0)")
    @firefox = UserAgent.parse("Mozilla/5.0 (Macintosh; U; Intel Mac OS X; en-US; rv:1.8.1.14) Gecko/20080404 Firefox/2.0.0.14")
    @opera_classic  = UserAgent.parse("Opera/9.27 (Windows NT 5.1; U; en)")
    @opera_mini = UserAgent.parse("Opera/9.80 (J2ME/MIDP; Opera Mini/9.80 (J2ME/23.377; U; en) Presto/2.5.25 Version/10.54")
    @iphone = UserAgent.parse("Mozilla/5.0 (iPhone; U; CPU like Mac OS X; en) AppleWebKit/420.1 (KHTML, like Gecko) Version/3.0 Mobile/4A102 Safari/419")
  end

  it "should be false for Internet Explorer" do
    @ie_7.should_not be_mobile
  end

  it "should be false for Firefox" do
    @firefox.should_not be_mobile
  end

  it "should be false for Opera" do
    @opera_classic.should_not be_mobile
  end

  it "should be true for Opera mini" do
    @opera_mini.should be_mobile
  end

  it "should be true for iPhone" do
    @iphone.should be_mobile
  end
end
