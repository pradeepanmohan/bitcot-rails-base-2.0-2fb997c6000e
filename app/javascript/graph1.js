
// JavaScript to create the pie chart dynamically
const data = [30, 20, 15, 25, 10]; // Data for the pie chart (percentages)
const colors = ['#4CAF50', '#2196F3', '#9C27B0', '#FF9800', '#FF5722'];

const svg = document.querySelector('svg');
const centerX = 150;
const centerY = 150;
const radius = 100;
let startAngle = 0;

for (let i = 0; i < data.length; i++) {
    const slice = document.getElementById('slice' + (i + 1));
    const angle = 360 * (data[i] / 100);
    const endAngle = startAngle + angle;

    const startX = centerX + radius * Math.cos(startAngle * Math.PI / 180);
    const startY = centerY + radius * Math.sin(startAngle * Math.PI / 180);

    const endX = centerX + radius * Math.cos(endAngle * Math.PI / 180);
    const endY = centerY + radius * Math.sin(endAngle * Math.PI / 180);

    const largeArcFlag = angle > 180 ? 1 : 0;

    const pathData = `M ${centerX},${centerY} L ${startX},${startY} A ${radius},${radius} 0 ${largeArcFlag},1 ${endX},${endY} Z`;
    slice.setAttribute('d', pathData);
    slice.setAttribute('fill', colors[i]);

    startAngle = endAngle;
}
