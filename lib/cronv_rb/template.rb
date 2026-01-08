# frozen_string_literal: true

require 'erb'
require 'time'

module CronvRb
  # rubocop:disable Metrics/ClassLength
  class Template
    TEMPLATE = <<~ERB
      <html>
      <head>
      <title><%= @v.option.title %> | <%= date_format(value: @v.time_from, format: "%Y/%-m/%-d %H:%M") %>, +<%= @v.option.duration %></title>
      <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
      </head>
      <body>
        <div class="container-fluid">
          <h1>
            <%= @v.option.title %>&nbsp;<small class="text-muted">From <%= date_format(value: @v.time_from, format: "%Y/%-m/%-d %H:%M") %>, +<%= @v.option.duration %></small>
          </h1>

          <br>

          <% if @v.extras.any? %>
            <h3>Extra</h3>
            <div id="cronv-extra" style="width:<%= @v.option.width %>%;">
              <dl class="row">
                <% @v.extras.each do |extra| %>
                  <dt class="col-sm-1"><%= extra.label %></dt>
                  <dd class="col-sm-11"><%= extra.job %></dd>
                <% end %>
              </dl>
            </div>
            <hr>
          <% end %>

          <h3>Timeline</h3>
          <div id="cronv-timeline" style="height:100%; width:<%= @v.option.width %>%;">
            <b>Loading...</b>
          </div>
        </div>
        <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
        <script type="text/javascript">
           google.charts.load("current", {packages:["timeline"]});
           google.charts.setOnLoadCallback(function() {
             var container = document.getElementById('cronv-timeline');
             var chart = new google.visualization.Timeline(container);
             var dataTable = new google.visualization.DataTable();
              dataTable.addColumn({ type: 'string', id: 'job' });
              dataTable.addColumn({ type: 'string', id: 'dummy bar label' });
              dataTable.addColumn({ type: 'string', role: 'tooltip' });
              dataTable.addColumn({ type: 'date', id: 'Start' });
              dataTable.addColumn({ type: 'date', id: 'End' });

              var tasks = {};
              <%# time_from = @v.time_from %>
              <%# time_to = @v.time_to %>
              <% @v.records.each do |cronv| %>
                <% job = js_escape_string(str: cronv.crontab.job) %>
                tasks['<%= job %>'] = tasks['<%= job %>'] || [];
                <% if running_every_minutes?(crontab: cronv.crontab) %>
                  tasks['<%= job %>'].push(['<%= job %>', '', 'Every minutes <%= job %>', <%= new_js_date(value: @v.time_from) %>, <%= new_js_date(value: @v.time_to) %>]);
                <% else %>
                  <% cronv_iter(cronv:).each do |exec| %>tasks['<%= job %>'].push(['<%= job %>', '', '<%= date_format(value: exec[:start], format: "%H:%M") %> <%= job %>', <%= new_js_date(value: exec[:start]) %>, <%= new_js_date(value: exec[:end]) %>]);<% end %>
                <% end %>
              <% end %>

              var taskByJobCount = [];
              for (var k in tasks) taskByJobCount.push({name: k, size: tasks[k].length});
              taskByJobCount.sort(function(a, b) {
                if (a.size == b.size) return 0;
                return a.size > b.size ? -1 : 1;
              });

              var rows = [];
              for (var i = 0; i < taskByJobCount.length; i++) {
                jobs = tasks[taskByJobCount[i].name];
                var jl = jobs.length;
                for (var j = 0; j < jl; j++) rows.push(jobs[j]);
              }

              if (rows.length > 0) {
                dataTable.addRows(rows);
                chart.draw(dataTable, {
                  timeline: {
                    colorByRowLabel: true
                  },
                  avoidOverlappingGridLines: false
                });
              } else {
                container.innerHTML = '<div class="alert alert-success"><strong>Woops!</strong> There is no data!</div>';
              }

              var mousePosX = undefined,
                  mousePosY = undefined;

              google.visualization.events.addListener(chart, 'onmouseover', function(e) {
                var t = document.getElementsByClassName("google-visualization-tooltip")[0];
                if (mousePosX) t.style.left = mousePosX + 'px';
                if (mousePosY) t.style.top = mousePosY - 120 + 'px';
              });

              document.addEventListener('mousemove', function(e) {
                mousePosX = e.pageX;
                mousePosY = e.pageY;
              });
           });

        </script>
      </body>
      </html>
    ERB

    def self.render(visualizer:)
      new(visualizer:).render
    end

    def render
      ERB.new(TEMPLATE).result(binding)
    end

    private_class_method :new

    private

    def initialize(visualizer:)
      @v = visualizer
    end

    def cronv_iter(cronv:)
      cronv.iter
    end

    def js_escape_string(str:)
      str.gsub(/['"\\]/) { |char| "\\#{char}" }.gsub("\n", '\\n').gsub("\r", '\\r')
    end

    def new_js_date(value:)
      time = value.is_a?(String) ? Time.parse(value) : value
      format('new Date(%<year>d, %<month>d, %<day>d, %<hour>d, %<min>d)', year: time.year, month: time.month - 1, day: time.day, hour: time.hour, min: time.min)
    end

    def date_format(value:, format:)
      time = value.is_a?(String) ? Time.parse(value) : value
      time.strftime(format)
    end

    def running_every_minutes?(crontab:)
      crontab.running_every_minutes?(crontab.schedule)
    end
  end
  # rubocop:enable Metrics/ClassLength
end
