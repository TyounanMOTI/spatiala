require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Matrix do
  before do
    @m1 = Matrix[[-2, -1,  0, 0],
                 [ 1,  2,  3, 0],
                 [ 1,  0, -1, 0],
                 [ 4,  2,  1, 1]]

    @m2 = Matrix[[ 3,  4,  1, 0],
                [-2,  0,  3, 0],
                [ 4, -1,  3, 0],
                [-1,  1,  3, 1]]
  end

  describe "initialize by Matrix[[a,b,c,d],[e,f,g,h]] format" do
    subject { Matrix[[1,2,3,4],[5,6,7,8]] }
    it { should == Matrix.new(Vector.new(1,2,3,4), Vector.new(5,6,7,8)) }
    it { should be_a Matrix }
  end

  it "should have row vector" do
    @m1.row(1).should == Vector.new(1, 2, 3, 0)
  end

  it "should have column vector" do
    @m1.column(1).should == Vector.new(-1, 2, 0, 2)
  end

  it "should return true when @m1 == Matrix.new(<<same value>>)" do
    @m1.should == Matrix[[-2, -1,  0, 0],
                        [ 1,  2,  3, 0],
                        [ 1,  0, -1, 0],
                        [ 4,  2,  1, 1]]
  end

  it "should return correct Matrix when multiply two matrix" do
    (@m1 * @m2).should == Matrix[[-4,-8,-5, 0],
                                 [11, 1,16, 0],
                                 [-1, 5,-2, 0],
                                 [11,16,16, 1]]
  end

  it "should return translation Matrix when Matrix.translator" do
    Matrix.translator(3, 4, 5).should == Matrix.new(Vector.new(1,0,0,0),
                                                        Vector.new(0,1,0,0),
                                                        Vector.new(0,0,1,0),
                                                        Vector.new(3,4,5,1))
  end

  it "should return correct Matrix when argument in Matrix.translator is < 3" do
    Matrix.translator(3).should == Matrix.new(Vector.new(1,0,0,0),
                                               Vector.new(0,1,0,0),
                                               Vector.new(0,0,1,0),
                                               Vector.new(3,0,0,1))
  end

  it "should generate rotation Matrix when Matrix.rotator" do
    Matrix.rotator(PI/6).should == Matrix.new(Vector.new(cos(PI/6), sin(PI/6), 0, 0),
                                                Vector.new(-sin(PI/6),cos(PI/6), 0, 0),
                                                Vector.new(0, 0, 1, 0),
                                                Vector.new(0, 0, 0, 1))
  end

  it "should generate scale Matrix when Matrix.scaler" do
    Matrix.scaler(5, 10).should == Matrix.new(Vector.new(5, 0, 0, 0),
                                                 Vector.new(0,10, 0, 0),
                                                 Vector.new(0, 0, 1, 0),
                                                 Vector.new(0, 0, 0, 1))
  end

  it "should generate reflection Matrix when Matrix.reflector" do
    Matrix.reflector(Vector.new(1,0,0)).should == Matrix.new(Vector.new(-1,0,0,0),
                                                      Vector.new(0,1,0,0),
                                                      Vector.new(0,0,1,0),
                                                      Vector.new(0,0,0,1))
  end

  describe "#transforms" do
    Translator = Matrix::Translator
    Rotator = Matrix::Rotator

    context "of a Translator" do
      subject { Translator[1,2,3].transforms }
      it { should == [Translator[1,2,3]] }
    end

    context "when chains Translator->Rotator" do
      subject { (Translator[1,2,3]*Rotator[PI/6]).transforms }
      it { should == [Translator[1,2,3],Rotator[PI/6]] }
    end

    context "when chains Translator->Translator->Rotator" do
      subject { (Translator[1,2,3]*Translator[4,3,2]*Rotator[PI/3]).transforms}
      it { should == [Translator[1,2,3],Translator[4,3,2],Rotator[PI/3]] }
    end
  end
end

shared_examples_for "a Matrix which have a inverse matrix" do
  describe "#inverse" do
    specify { (subject*subject.inverse).should == Matrix.I_4 }
  end
end

describe Matrix::Translator do
  Translator = Matrix::Translator

  it "can initialize by Translator[x,y,z] format" do
    Translator[3,2,1].should == Matrix[[1,0,0,0],
                                       [0,1,0,0],
                                       [0,0,1,0],
                                       [3,2,1,1]]
  end

  it "can initialize by 'new'" do
    Translator.new(3,2,1).should == Matrix[[1,0,0,0],
                                           [0,1,0,0],
                                           [0,0,1,0],
                                           [3,2,1,1]]
  end

  describe "#inverse" do
    context "when Translator[1,2,3]" do
      subject { Translator[1,2,3].inverse }
      specify do
        should == Matrix[[1,0,0,0],
                         [0,1,0,0],
                         [0,0,1,0],
                         [-1,-2,-3,1]]
      end
      it_behaves_like "a Matrix which have a inverse matrix"
    end
  end
end

describe Matrix::Scaler do
  Scaler = Matrix::Scaler

  specify do
    Scaler[1,2,3].should == Matrix[
                                   [1,0,0,0],
                                   [0,2,0,0],
                                   [0,0,3,0],
                                   [0,0,0,1]
                                  ]
  end

  describe "#inverse" do
    subject { Scaler[1,2,3].inverse }
    it_behaves_like "a Matrix which have a inverse matrix"
  end
end

describe Matrix::Reflector do
  specify do
    Matrix::Reflector[1,0,0].should == Matrix[
                                              [-1,0,0,0],
                                              [0,1,0,0],
                                              [0,0,1,0],
                                              [0,0,0,1]
                                             ]
  end
end

describe Matrix::Rotator do
  specify do
    Matrix::Rotator[PI/6].should == Matrix[
                                   [cos(PI/6),sin(PI/6),0,0],
                                   [-sin(PI/6),cos(PI/6),0,0],
                                   [0,0,1,0],
                                   [0,0,0,1]
                                  ]
  end
end
