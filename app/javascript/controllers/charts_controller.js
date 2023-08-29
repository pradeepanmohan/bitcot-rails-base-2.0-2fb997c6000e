import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    connect() {
        this.element.textContent = "Chart !!!!"

        fetch('/users')
            .then(response => response.json())
    .then(data => this.drawChart(data));
        // this.drawChart();


    }

    drawChart(data1) {
        console.log("Hai chart")

        google.charts.load('current', { 'packages':['corechart'] });
        google.charts.setOnLoadCallback(() => {
            var data = google.visualization.arrayToDataTable(data1);

        var options = {
            title: 'Population of Largest U.S. Cities',
            legend: { position: 'none' },
        };

        console.log("opt", options)
        var chart = new google.visualization.ColumnChart(this.element);
        chart.draw(data, options);
    });
    }
}
