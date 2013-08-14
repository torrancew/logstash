require "test_utils"
require "logstash/util/fieldreference"

describe LogStash::Util::FieldReference, :if => true do
  it "should permit simple key names" do
    str = "hello"
    m = eval(subject.compile(str))
    data = { "hello" => "world" }
    insist { m.call(data) } == data[str]
  end

  it "should permit [key][access]" do
    str = "[hello][world]"
    m = eval(subject.compile(str))
    data = { "hello" => { "world" => "foo", "bar" => "baz" } }
    insist { m.call(data) } == data["hello"]["world"]
  end
  it "should permit [key][access]" do
    str = "[hello][world]"
    m = eval(subject.compile(str))
    data = { "hello" => { "world" => "foo", "bar" => "baz" } }
    insist { m.call(data) } == data["hello"]["world"]
  end
  
  it "should permit blocks" do
    str = "[hello][world]"
    code = subject.compile(str)
    m = eval(subject.compile(str))
    data = { "hello" => { "world" => "foo", "bar" => "baz" } }
    m.call(data) { |obj, key| obj.delete(key) }

    # Make sure the "world" key is removed.
    insist { data["hello"] } == { "bar" => "baz" }
  end

  it "should permit blocks #2" do
    str = "simple"
    code = subject.compile(str)
    m = eval(subject.compile(str))
    data = { "simple" => "things" }
    m.call(data) { |obj, key| obj.delete(key) }
    insist { data }.empty?
  end
end
