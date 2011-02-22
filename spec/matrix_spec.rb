require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

shared_examples_for "a Matrix which have an inverse matrix" do
  specify { (subject*subject.inverse).should == Matrix::I_4.new }
end

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

  describe "#inverse" do
    context "which is chain of Translator->Rotator" do
      subject { (Translator[1,2,3]*Rotator[PI/6]).inverse }
      it_behaves_like "a Matrix which have an inverse matrix"
    end
  end

  describe "#transforms" do
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

describe Matrix::Translator do
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
      it_behaves_like "a Matrix which have an inverse matrix"
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
    it_behaves_like "a Matrix which have an inverse matrix"
  end
end

describe Matrix::Reflector do
  specify do
    Reflector[1,0,0].should == Matrix[
                                      [-1,0,0,0],
                                      [0,1,0,0],
                                      [0,0,1,0],
                                      [0,0,0,1]
                                     ]
  end

  describe "#inverse" do
    subject { Reflector[1,0,0].inverse }
    it_behaves_like "a Matrix which have an inverse matrix"
  end
end

describe Matrix::Rotator do
  specify do
    Rotator[PI/6].should == Matrix[
                                   [cos(PI/6),sin(PI/6),0,0],
                                   [-sin(PI/6),cos(PI/6),0,0],
                                   [0,0,1,0],
                                   [0,0,0,1]
                                  ]
  end

  describe "#inverse" do
    subject { Rotator[PI/6].inverse }
    it_behaves_like "a Matrix which have an inverse matrix"
  end
end
