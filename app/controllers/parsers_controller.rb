# frozen_string_literal: true

class ParsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user

  def input
    @user.parsers.create!(txt: '', input_type: 'plain') if @user.parsers.first.nil?
    @parser = @user.parsers.first
  end

  def output
    if request.patch?
      @user.parsers.first.update! parser_params
      @parser = @user.parsers.first
      if @parser.txt.present?
        parsed_txt = parse_by_type(@parser.txt, @parser[:input_type])

        # Clear records not related
        @parser.results.destroy_all
        natto = Natto::MeCab.new
        natto.parse(parsed_txt) do |n|
          f = n.feature.split(',')
          break if f[0] == 'BOS/EOS'

          @parser.results.create(surface: n.surface,
                                 part_of_speech: f[0],
                                 part_division1: f[1],
                                 part_division2: f[2],
                                 part_division3: f[3],
                                 type_of_conjugation: f[4],
                                 form_of_conjugation: f[5],
                                 model: f[6],
                                 yomi: f[7],
                                 pronunciation: f[8])
        end
        set_pie_chart_data(@parser.results, :part_of_speech)
        set_bar_chart_data(@parser.results)

        @results = @parser.results.page(params[:page])

        render 'output'
      else
        flash[:warning] = '入力が空です'
        redirect_to root_path
      end
    else
      @parser = @user.parsers.first

      if params[:word_key]
        @results = @user.parsers.first.results
                       .where('part_of_speech LIKE ? OR surface LIKE ?',
                              "%#{params[:word_key]}%",
                              "%#{params[:word_key]}%")
                       .page(params[:page])
      else
        @results = @user.parsers.first.results.page(params[:page])
      end
      set_pie_chart_data(@user.parsers.first.results, :part_of_speech)
      set_bar_chart_data(@user.parsers.first.results)
      render 'output'
    end
  end

  def csv_out
    @parser = @user.parsers.first
    column_names = %w[表層形 品詞 品詞細分類1 品詞細分類2 品詞細分類3 活用型 活用形 原形 読み 発音]

    csv_data = CSV.generate do |csv|
      csv << column_names
      @parser.results.each do |result|
        csv << [result.surface,
                result.part_of_speech,
                result.part_division1,
                result.part_division2,
                result.part_division3,
                result.type_of_conjugation,
                result.form_of_conjugation,
                result.model,
                result.yomi,
                result.pronunciation]
      end
    end
    send_data(csv_data, filename: 'result.csv')
  end

  private

  def set_user
    @user = current_user
  end

  def parser_params
    params.require(:parser).permit(:txt, :input_type)
  end

  def scrape_body(e)
    doc = Nokogiri::HTML(e)
    doc = doc.xpath('//script|//style|//img|//noscript').remove
    doc.xpath('//body').inner_text.gsub(/[\s]+/, ' ')
  end

  def parse_by_type(txt, input_type)
    case input_type
    when 'plain' then
      txt
    when 'markup' then
      scrape_body(txt)
    when 'url' then
      opt = {}
      opt['User-Agent'] = 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.108 Safari/537.36 '

      begin
        html = open(txt, opt) do |f|
          f.read
        end
      rescue StandardError
        return ''
      end

      scrape_body(html)
    end
  end

  def set_pie_chart_data(table, column)
    @pie_chart_data = {}
    chart_items = table.pluck(column).uniq

    chart_items.each do |chart_item|
      count = table.where(column => chart_item).count
      @pie_chart_data[chart_item] = count
    end
  end

  def set_bar_chart_data(table)
    @bar_chart_data = table
                          .where('part_of_speech = ? AND (part_division1 = ? OR part_division1 = ?)', '名詞', '固有名詞', '一般')
                          .limit(10)
                          .group('surface')
                          .order('count_surface desc')
                          .count('surface')
  end

end
