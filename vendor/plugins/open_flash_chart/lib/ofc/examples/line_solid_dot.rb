module OFC
  module Examples
    module LineSolidDot
      # http://teethgrinder.co.uk/open-flash-chart-2/line-solid-dot.php
      def line_solid_dot
        #$data = array();
        data = []

        #for( $i=0; $i<6.2; $i+=0.2 )
        #{
        #  $data[] = (sin($i) * 1.9) + 4;
        #}
        (0..31).each do |x|
          data << (Math.sin(x * 0.2) * 1.9) + 4
        end

        #$title = new title( date("D M d Y") );
        title = OFC::Title.new(:text => Time.now.strftime("%a %b %d %Y"))

        #// ------- LINE 2 -----
        #$d = new solid_dot();
        #$d->size(3)->halo_size(1)->colour('#3D5C56');
        d = OFC::SolidDot.new(:dot_size => 3, :halo_size => 1, :colour => '#3D5C56')

        #$line = new line();
        #$line->set_default_dot_style($d);
        #$line->set_values( $data );
        #$line->set_width( 2 );
        #$line->set_colour( '#3D5C56' );
        line = OFC::Line.new(:dot_style => d, :values => data, :width => 2, :colour => '#3D5C56')


        #$y = new y_axis();
        #$y->set_range( 0, 8, 4 );
        y = OFC::YAxis.new(:min => 0, :max => 8, :steps => 4)


        #$chart = new open_flash_chart();
        #$chart->set_title( $title );
        #$chart->add_element( $line );
        #$chart->set_y_axis( $y );
        chart = OFC::OpenFlashChart.new(:title => title, :elements => [line], :y_axis => y)

        #echo $chart->toPrettyString();
        render :text => chart.render
      end
    end
  end
end
