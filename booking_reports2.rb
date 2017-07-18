class BookingReports < Prawn::Document
  # ширина колонок
  Widths = [200, 200, 120]
  # заглавия колонок
  Headers = ['Дата добавления', 'Клиент', 'Баланс']
  
  def row(check_in, check_out, room_id)
    row = [check_in, check_out, room_id]
    make_table([row]) do |t|
      t.column_widths = Widths
      t.cells.style :borders => [:left, :right], :padding => 2
    end
  end
    
  def to_pdf
    # привязываем шрифты
        font_families.update(
      "Helvetica" => {
        :bold => "#{Rails.root}/app/fonts/Helvetica Neue Condensed Bold.ttf",
        :normal  => "#{Rails.root}/app/fonts/Helvetica Neue Condensed Black.ttf" })
    font "Helvetica", :size => 10
    text "Отчет за #{Time.zone.now.strftime('%b %Y')}", :size => 15, :style => :bold, :align => :center
    move_down(18)
    # выборка записей
    @customers = Customer.order('created_at')
    data = []
    items = @customers.each do |item|
      data << row(item.created_at.strftime('%d/%m/%y %H:%M'), item.friendly_name, item.)
    end
    
    head = make_table([Headers], :column_widths => Widths)
    table([[head], *(data.map{|d| [d]})], :header => true, :row_colors => %w[cccccc ffffff]) do
      row(0).style :background_color => '000000', :text_color => 'ffffff'
      cells.style :borders => []
    end
    # добавим время создания внизу страницы
    creation_date = Time.zone.now.strftime("Отчет сгенерирован %e %b %Y в %H:%M")
    go_to_page(page_count)
    move_down(710)
    text creation_date, :align => :right, :style => :normal, :size => 9
    render
  end
  
end

  def booking_rows
    [['#', 'Name', 'Price'],[@booking.id, @booking.check_in.to_s + "<->" + @booking.check_out.to_s, @booking.subtotal]]

  end

end