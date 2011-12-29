$(document).ready(function(){
	$("input[name=id]").click(function(){
		var id_prod = $(this).val();
		$.ajax({
			url:"/cart/add/"+ id_prod + ".js"
		})
	});
});