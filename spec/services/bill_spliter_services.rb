require 'rails_helper'

RSpec.describe BillSplitterService do
  # .remove_remainderメソッドのテスト
  # describe '.remove_remainde' do
  #   it '支払い金額と有効桁数が与えられたとき、有効桁数に変換された金額が正しく計算されるか' do
  #     total_amount = 33_333
  #     rounding_rule = 10
  #     expect(BillSplitter.send(:remove_remainder, total_amount, rounding_rule)).to eq 33_330
  #   end

  #   it '支払い金額のみ与えられたとき、デフォルト値で有効桁数に変換された金額が正しく計算されるか' do
  #     total_amount = 33_333
  #     expect(BillSplitter.send(:remove_remainder, total_amount)).to eq 33_300
  #   end
  # end
end
