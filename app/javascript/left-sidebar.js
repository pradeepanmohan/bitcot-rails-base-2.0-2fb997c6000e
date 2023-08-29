
$( "li.has-subnav a").click(function(e) {
	console.log("Hiiii");
	$(this).parent().toggleClass("open");
});

document.querySelector(".toggle-sidebar").addEventListener("click", function(e) {
	document.querySelector(".sidebar-wrapper").classList.toggle("open");
});

document.querySelector(".toggle-sidebar").addEventListener("click", function(e) {
	var sidebarWrapper = document.querySelector(".sidebar-wrapper");
	var hasSubnavs = document.querySelectorAll(".has-subnav");
	if (!sidebarWrapper.classList.contains("open")) {
		for (var i = 0; i < hasSubnavs.length; i++) {
			hasSubnavs[i].classList.remove("open");
		}
	} else {
		// You can add code here if needed for the else case
	}
});