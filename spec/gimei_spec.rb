# coding: utf-8
require_relative 'spec_helper'

describe Gimei do
  describe '.male' do
    before { @name = Gimei.male }

    it 'Gimei::Name オブジェクトが返ること' do
      @name.must_be_instance_of Gimei::Name
    end

    it '#male? が true を返すこと' do
      @name.male?.must_equal true
    end
  end

  describe '.female' do
    before { @name = Gimei.female }

    it 'Gimei::Name オブジェクトが返ること' do
      @name.must_be_instance_of Gimei::Name
    end

    it '#female? が true を返すこと' do
      @name.female?.must_equal true
    end
  end

  describe '#kanji' do
    it '全角文字とスペースが返ること' do
      Gimei.new.kanji.must_match /\A[#{Moji.zen}\s]+\z/
    end
  end

  describe '#to_s' do
    it '全角文字とスペースが返ること' do
      Gimei.new.to_s.must_match /\A[#{Moji.zen}\s]+\z/
    end
  end

  describe '.kanji' do
    it '全角文字とスペースが返ること' do
      Gimei.kanji.must_match /\A[#{Moji.zen}\s]+\z/
    end
  end

  describe '#hiragana' do
    it 'ひらがなとスペースが返ること' do
      Gimei.new.hiragana.must_match /\A[\p{hiragana}\s]+\z/
    end
  end

  describe '.hiragana' do
    it 'ひらがなとスペースが返ること' do
      Gimei.hiragana.must_match /\A[\p{hiragana}\s]+\z/
    end
  end

  describe '#katakana' do
    it 'カタカナとスペースが返ること' do
      Gimei.new.katakana.must_match /\A[\p{katakana}\s]+\z/
    end
  end

  describe '.katakana' do
    it 'カタカナとスペースが返ること' do
      Gimei.katakana.must_match /\A[\p{katakana}\s]+\z/
    end
  end

  describe '.name' do
    it 'Gimei::Name オブジェクトが返ること' do
      Gimei.name.must_be_instance_of Gimei::Name
    end
  end

  describe '#name' do
    it 'Gimei::Name オブジェクトが返ること' do
      Gimei.new.name.must_be_instance_of Gimei::Name
    end
  end

  describe '.first' do
    it 'Gimei::Name::First オブジェクトが返ること' do
      Gimei.first.must_be_instance_of Gimei::Name::First
    end
  end

  describe '#first' do
    it 'Gimei::Name::First オブジェクトが返ること' do
      Gimei.new.first.must_be_instance_of Gimei::Name::First
    end
  end

  describe '.last' do
    it 'Gimei::Name::First オブジェクトが返ること' do
      Gimei.last.must_be_instance_of Gimei::Name::Last
    end
  end

  describe '#last' do
    it 'Gimei::Name::First オブジェクトが返ること' do
      Gimei.new.last.must_be_instance_of Gimei::Name::Last
    end
  end

  describe '.romaji' do
    it 'ローマ字とスペースが返ること' do
      Gimei.romaji.must_match(/\A[a-zA-Z\s]+\z/)
    end
  end

  describe '#romaji' do
    it 'ローマ字とスペースが返ること' do
      Gimei.new.romaji.must_match(/\A[a-zA-Z\s]+\z/)
    end
  end

  describe '.address' do
    it 'Gimei::Address オブジェクトが返ること' do
      Gimei.address.must_be_instance_of Gimei::Address
    end
  end

  describe '#address' do
    it 'Gimei::Address オブジェクトが返ること' do
      Gimei.new.address.must_be_instance_of Gimei::Address
    end
  end

  describe '.prefecture' do
    it 'Gimei::Address::Prefecture オブジェクトが返ること' do
      Gimei.prefecture.must_be_instance_of Gimei::Address::Prefecture
    end
  end

  describe '#prefecture' do
    it 'Gimei::Address::Prefecture オブジェクトが返ること' do
      Gimei.new.prefecture.must_be_instance_of Gimei::Address::Prefecture
    end
  end

  describe '.city' do
    it 'Gimei::Address::City オブジェクトが返ること' do
      Gimei.city.must_be_instance_of Gimei::Address::City
    end
  end

  describe '#city' do
    it 'Gimei::Address::City オブジェクトが返ること' do
      Gimei.new.city.must_be_instance_of Gimei::Address::City
    end
  end

  describe '.town' do
    it 'Gimei::Address::Town オブジェクトが返ること' do
      Gimei.town.must_be_instance_of Gimei::Address::Town
    end
  end

  describe '#town' do
    it 'Gimei::Address::Town オブジェクトが返ること' do
      Gimei.new.town.must_be_instance_of Gimei::Address::Town
    end
  end

  describe '.unique' do
    describe '#name' do
      describe '名前が枯渇していないとき' do
        it '一意な名前(フルネームの漢字単位)が返ること' do
          original_names = Gimei::NAMES
          Gimei::NAMES = {
            'first_name' => { 'male' => [%w[真一 しんいち シンイチ]], 'female' => [] },
            'last_name' => [%w[前島 まえしま マエシマ], %w[神谷 かみや カミヤ]]
          }
          [Gimei.unique.name.kanji, Gimei.unique.name.kanji].sort.must_equal ['前島 真一', '神谷 真一']
          Gimei::NAMES = original_names
        end
      end

      describe '名前が枯渇したとき' do
        it 'Gimei::RetryLimitExceededed例外が発生すること' do
          original_names = Gimei::NAMES
          Gimei::NAMES = {
            'first_name' => { 'male' => [], 'female' => [] },
            'last_name' => []
          }
          assert_raises Gimei::RetryLimitExceeded do
            Gimei.unique.name
          end
          Gimei::NAMES = original_names
        end
      end
    end

    describe '#first' do
      describe '名が枯渇していないとき' do
        it '一意な名(漢字単位)が返ること' do
          original_names = Gimei::NAMES
          Gimei::NAMES = {
            'first_name' => { 'male' => [%w[真一 しんいち シンイチ]], 'female' => [%w[花子 はなこ ハナコ]] },
            'last_name' => %w[]
          }
          [Gimei.unique.first.kanji, Gimei.unique.first.kanji].sort.must_equal %w[真一 花子]
          Gimei::NAMES = original_names
        end
      end

      describe '名が枯渇したとき' do
        it 'Gimei::RetryLimitExceeded例外が発生すること' do
          original_names = Gimei::NAMES
          Gimei::NAMES = {
            'first_name' => { 'male' => [], 'female' => [] },
            'last_name' => []
          }
          assert_raises Gimei::RetryLimitExceeded do
            Gimei.unique.first
          end
          Gimei::NAMES = original_names
        end
      end
    end

    describe '#last' do
      describe '姓が枯渇していないとき' do
        it '一意な姓(漢字単位)が返ること' do
          original_names = Gimei::NAMES
          Gimei::NAMES = {
            'first_name' => { 'male' => [], 'female' => [] },
            'last_name' => [%w[前島 まえしま マエシマ], %w[神谷 かみや カミヤ]]
          }
          [Gimei.unique.last.kanji, Gimei.unique.last.kanji].sort.must_equal %w[前島 神谷]
          Gimei::NAMES = original_names
        end
      end

      describe '姓が枯渇したとき' do
        it 'Gimei::RetryLimitExceeded例外が発生すること' do
          original_names = Gimei::NAMES
          Gimei::NAMES = {
            'first_name' => { 'male' => [], 'female' => [] },
            'last_name' => []
          }
          assert_raises Gimei::RetryLimitExceeded do
            Gimei.unique.last
          end
          Gimei::NAMES = original_names
        end
      end
    end

    describe '#address' do
      describe '住所が枯渇していないとき' do
        it '一意な住所(漢字単位)が返ること' do
          original_addresses = Gimei::ADDRESSES
          Gimei::ADDRESSES = {
            'addresses' => [
              'prefecture' => [%w[東京都 とうきょうと トウキョウト]],
              'city' => [%w[渋谷区 しぶやく シブヤク]],
              'town' => [%w[恵比寿 えびす エビス], %w[蛭子 えびす エビス]]
            ]
          }
          [Gimei.unique.address.kanji, Gimei.unique.address.kanji].sort.must_equal %w[東京都渋谷区恵比寿 東京都渋谷区蛭子]
          Gimei::ADDRESSES = original_addresses
        end
      end

      describe '住所が枯渇したとき' do
        it 'Gimei::RetryLimitExceeded例外が発生すること' do
          original_addresses = Gimei::ADDRESSES
          Gimei::ADDRESSES = {
            'addresses' => [
              'prefecture' => [],
              'city' => [],
              'town' => []
            ]
          }
          assert_raises Gimei::RetryLimitExceeded do
            Gimei.unique.address
          end
          Gimei::ADDRESSES = original_addresses
        end
      end
    end

    describe '#prefecture' do
      describe '県が枯渇していないとき' do
        it '一意な県が返ること' do
          original_addresses = Gimei::ADDRESSES
          Gimei::ADDRESSES = {
            'addresses' => [
              'prefecture' => [%w[東京都 とうきょうと トウキョウト], %w[静岡県 しずおかけん シズオカケン]],
              'city' => [],
              'town' => []
            ]
          }
          [Gimei.unique.prefecture.kanji, Gimei.unique.prefecture.kanji].sort.must_equal %w[東京都 静岡県]
          Gimei::ADDRESSES = original_addresses
        end
      end

      describe '県が枯渇したとき' do
        it 'Gimei::RetryLimitExceeded例外が発生すること' do
          original_addresses = Gimei::ADDRESSES
          Gimei::ADDRESSES = {
            'addresses' => [
              'prefecture' => [],
              'city' => [],
              'town' => []
            ]
          }
          assert_raises Gimei::RetryLimitExceeded do
            Gimei.unique.prefecture
          end
          Gimei::ADDRESSES = original_addresses
        end
      end
    end

    describe '#city' do
      describe '市区町村が枯渇していないとき' do
        it '一意な市区町村が返ること' do
          original_addresses = Gimei::ADDRESSES
          Gimei::ADDRESSES = {
            'addresses' => [
              'prefecture' => [],
              'city' => [%w[渋谷区 しぶやく シブヤク], %w[新宿区 しんじゅくく シンジュクク]],
              'town' => []
            ]
          }
          [Gimei.unique.city.kanji, Gimei.unique.city.kanji].sort.must_equal %w[新宿区 渋谷区]
          Gimei::ADDRESSES = original_addresses
        end
      end

      describe '市区町村が枯渇したとき' do
        it 'Gimei::RetryLimitExceeded例外が発生すること' do
          original_addresses = Gimei::ADDRESSES
          Gimei::ADDRESSES = {
            'addresses' => [
              'prefecture' => [],
              'city' => [],
              'town' => []
            ]
          }
          assert_raises Gimei::RetryLimitExceeded do
            Gimei.unique.city
          end
          Gimei::ADDRESSES = original_addresses
        end
      end
    end

    describe '#town' do
      describe 'その他住所が枯渇していないとき' do
        it '一意なその他住所が返ること' do
          original_addresses = Gimei::ADDRESSES
          Gimei::ADDRESSES = {
            'addresses' => [
              'prefecture' => [],
              'city' => [],
              'town' => [%w[恵比寿 えびす エビス], %w[蛭子 えびす エビス]]
            ]
          }
          [Gimei.unique.address.kanji, Gimei.unique.address.kanji].sort.must_equal %w[恵比寿 蛭子]
          Gimei::ADDRESSES = original_addresses
        end
      end

      describe 'その他住所が枯渇したとき' do
        it 'Gimei::RetryLimitExceeded例外が発生すること' do
          original_addresses = Gimei::ADDRESSES
          Gimei::ADDRESSES = {
            'addresses' => [
              'prefecture' => [],
              'city' => [],
              'town' => []
            ]
          }
          assert_raises Gimei::RetryLimitExceeded do
            Gimei.unique.town
          end
          Gimei::ADDRESSES = original_addresses
        end
      end
    end
  end
end
