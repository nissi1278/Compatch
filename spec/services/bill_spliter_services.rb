require 'rails_helper'

RSpec.describe BillSplitterService, type: :service do
  # テスト用の簡易的な参加者オブジェクトを作成
  Participant = Struct.new(:name, :is_manual_fixed, :payment_amount)

  # publicメソッドである #call のテストを記述
  describe '#call' do
    subject(:result) { described_class.new(total_amount, participants, floor_digits: floor_digits).call }

    let(:total_amount) { 10_000 }
    let(:floor_digits) { 0 }
    let(:participants) do
      [
        Participant.new('Aさん', true, 5000), # 固定
        Participant.new('Bさん', false, nil), # 割り勘
        Participant.new('Cさん', false, nil) # 割り勘
      ]
    end

    context '正常な割り勘の場合' do
      it '正しく計算され、表示用の行データが返されること' do
        # payment_rowsの検証
        expect(result[:payment_rows].count).to eq 2
        # 割り勘グループの検証
        expect(result[:payment_rows][0][:amount]).to eq 2500
        expect(result[:payment_rows][0][:participants].map(&:name)).to match_array(%w[Bさん Cさん])
        # 固定額グループの検証
        expect(result[:payment_rows][1][:amount]).to eq 5000
        expect(result[:payment_rows][1][:participants].map(&:name)).to contain_exactly('Aさん')
      end

      it '正しく計算され、表示用のサマリーが返されること' do
        # --- 期待される結果 ---
        # 残額: 10000 - 5000 = 5000
        # 割り勘額: 5000 / 2人 = 2500
        # 支払い合計: 5000 + 2500 + 2500 = 10000
        # 端数: 10000 - 10000 = 0
        expect(result[:summary][:total_amount]).to eq 10_000
        expect(result[:summary][:total_paid]).to eq 10_000
        expect(result[:summary][:remainder]).to eq 0
      end
    end

    context '桁数切り捨てがある場合' do
      let(:total_amount) { 10_550 }
      let(:floor_digits) { 2 } # 100円単位に切り捨て

      it '先に全体を切り捨ててから計算されること' do
        # --- 期待される結果 ---
        # 切り捨て後の全体額: 10500
        # 割り勘対象額: 10500 - 5000 = 5500
        # 割り勘額: 5500 / 2人 = 2750
        # 支払い合計: 5000 + 2750 + 2750 = 10500
        # 端数: 10550 - 10500 = 50

        expect(result[:payment_rows][0][:amount]).to eq 2750
        expect(result[:payment_rows][1][:amount]).to eq 5000
        expect(result[:summary][:total_paid]).to eq 10_500
        expect(result[:summary][:remainder]).to eq 50
      end
    end

    context '固定額が割り勘額と偶然一致する場合' do
      let(:total_amount) { 15_000 }
      let(:participants) do
        [
          Participant.new('Aさん', true, 5000),  # 固定額が割り勘額と同じ
          Participant.new('Bさん', true, 5000),  # 固定
          Participant.new('Cさん', false, nil) # 割り勘 (5000になるはず)
        ]
      end

      it '同じ金額の参加者が一つの行にまとめられること' do
        # --- 期待される結果 ---
        # A: 2500, B: 5000, C: 1250, D: 1250
        # グループ化: { 1250 => [C,D], 2500 => [A], 5000 => [B] }
        # 期待値: total 15000, fixed(A,B) = 10000, to_split = 5000, base_amount(C) = 5000
        # 全員5000円になる

        expect(result[:payment_rows].count).to eq 1
        expect(result[:payment_rows][0][:amount]).to eq 5000
        expect(result[:payment_rows][0][:participants].map(&:name)).to match_array(%w[Aさん Bさん Cさん])
      end
    end

    context '参加者がいない場合' do
      let(:participants) { [] }

      it 'デフォルトの空の結果が返されること' do
        expect(result[:payment_rows]).to be_empty
        expect(result[:summary][:total_amount]).to eq 10_000
        expect(result[:summary][:total_paid]).to eq 0
        expect(result[:summary][:remainder]).to eq 10_000
      end
    end

    context '全員が割り勘の場合' do
      let(:participants) do
        [
          Participant.new('Aさん', false, nil),
          Participant.new('Bさん', false, nil),
          Participant.new('Cさん', false, nil),
          Participant.new('Dさん', false, nil)
        ]
      end

      it '均等に分割されること' do
        # 10000 / 4 = 2500
        expect(result[:payment_rows].count).to eq 1
        expect(result[:payment_rows][0][:amount]).to eq 2500
        expect(result[:summary][:remainder]).to eq 0
      end
    end
  end
end
