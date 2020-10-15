
var rgbStart = [139,195,74]
var rgbEnd = [183,28,28]

$(function(){
	window.addEventListener('message', function(event) {
		if (event.data.action == "setValue"){
			if (event.data.key == "job"){
				setJobIcon(event.data.icon)
			}
			setValue(event.data.key, event.data.value)

		}else if (event.data.action == "updateStatus"){
			updateStatus(event.data.status);
		}else if (event.data.action == "setTalking"){

			setTalking(event.data.value)
		}else if (event.data.action == "setPasy"){
			changePasyHeart(event.data.value, event.data.amount)
		}else if (event.data.action == "setProximity"){
			setProximity(event.data.value)
		}else if (event.data.action == "toggle"){
			if (event.data.show){
				$('#ui').show();
			} else{
				$('#ui').hide();
			}
		} else if (event.data.action == "toggleCar"){
			if (event.data.show){
				$('.carStats').show();
			} else{
				$('.carStats').hide();
			}
		}else if (event.data.action == "updateCarStatus"){
			updateCarStatus(event.data.status)
		}else if (event.data.action == "setNewIcons"){
			changePasyHeartIcon(event.data.value)
		}
	});

});

function updateWeight(weight){


	var bgcolor = colourGradient(weight/100, rgbEnd, rgbStart)
	$('#weight .bg').css('height', weight+'%')
	$('#weight .bg').css('background-color', 'rgb(' + bgcolor[0] +','+ bgcolor[1] +','+ bgcolor[2] +')')
}

function updateCarStatus(status){
	var gas = status[0]
	$('#gas .bg').css('height', gas.percent+'%')
	var bgcolor = colourGradient(gas.percent/100, rgbStart, rgbEnd)
	//var bgcolor = colourGradient(0.1, rgbStart, rgbEnd)
	//$('#gas .bg').css('height', '10%')
	$('#gas .bg').css('background-color', 'rgb(' + bgcolor[0] +','+ bgcolor[1] +','+ bgcolor[2] +')')
}

function setValue(key, value){
	$('#'+key+' span').html(value)

}

function setJobIcon(value){
	$('#job img').attr('src', 'img/jobs/'+value+'.png')
}

function updateStatus(status){
	var hunger = status[0].value;
	var thirst = status[1].value;
	console.log(hunger);
	//var drunk = status[2]
	$('#hunger .bg').css('height', hunger+'%')
	$('#water .bg').css('height', thirst+'%')
	//$('#drunk .bg').css('height', drunk.percent+'%');
	//if (drunk.percent > 0){
		//$('#drunk').show();
	//}else{
		//$('#drunk').show();
	//}

}

function changePasyHeart(value, amount){
	if(value == 'heart'){
		var healthPercent = amount-100;

		$('#pasy .bg').css('height', healthPercent+'%')
	}else if(value == 'pasy'){
		if(amount){
			$('#pasy .bg').css('height', 100+'%')
		}else{
			$('#pasy .bg').css('height', 0+'%')
		}
	}
}

function changePasyHeartIcon(value){
	if(value == 'heart'){
		$('#heartandpasy').attr('src', 'img/heart.png');
	}else if(value == 'pasy'){
		$('#heartandpasy').attr('src', 'img/pasy.png');
	}
}


function setPasy(value){
	if (value){
		//#64B5F6
		percentpp = 100
		$('#pasy .bg').css('height', percentpp+'%')
	}else{
		//#81C784
		
		percentpp = 0
		$('#pasy .bg').css('height', percentpp+'%')
	}

}

function setProximity(value){
	var color;
	var speaker;
	if (value == "whisper"){
		color = "rgba(99, 0, 0, 0.6);";
		speaker = 1;
		$('#voice .bg').css('height', 25+'%')
	}else if (value == "normal"){
		color = "rgba(99, 0, 0, 0.6);"
		speaker = 2;
		
		$('#voice .bg').css('height', 55+'%')
	}else if (value == "shout"){
		color = "rgba(99, 0, 0, 0.6)"
		speaker = 3;
		
		$('#voice .bg').css('height', 100+'%')

	}
	$('#voice .bg').css('background-color', color);
	$('#voice img').attr('src', 'img/speaker'+speaker+'.png');
}	

function setTalking(value){
	if (value){
		//#64B5F6box-shadow: 0 0 15px #000000;
		$('#voice').css('box-shadow', '0 0 10px inset #e51919')
		$('#voice').css('transiton', '1500ms')
	}else{
		//#81C784
		$('#voice').css('box-shadow', '0 0 15px #000000')
		$('#voice').css('transiton', '1500ms')
	}
}

//API Shit
function colourGradient(p, rgb_beginning, rgb_end){
    var w = p * 2 - 1;

    var w1 = (w + 1) / 2.0;
    var w2 = 1 - w1;

    var rgb = [parseInt(rgb_beginning[0] * w1 + rgb_end[0] * w2),
        parseInt(rgb_beginning[1] * w1 + rgb_end[1] * w2),
            parseInt(rgb_beginning[2] * w1 + rgb_end[2] * w2)];
    return rgb;
};