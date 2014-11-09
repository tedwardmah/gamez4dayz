// Global stuffffffff

$hangmanContainer = null;
$hangmanWord = null;
$hangmanTries = null;
$hangmanForm = null;
$tictactoeGameOver = false
var hangmanGuessedLetters;

// Hangman stufffffff **************************************************

function setHangmanConstants(){
  $hangmanContainer = $($('.hangman-container')[0]);
  $hangmanWord = $($(".hangman-word-display")[0]);
  $hangmanTries = $($(".hangman-tries-display")[0]);
  $hangmanForm = $($(".hangman-form")[0]);
}

function updateHangmanHTML(new_word_display, tries_remaining){
  $hangmanWord.text(new_word_display);
  $hangmanTries.text(("Tries remaining: " + tries_remaining));
  $(".hangman-guess").val('');
}

function updateHangmanImg(tries_remaining){
  $hangmanImg = $($('.hangman-img')[0]);
  var new_src = ("/images/hangman/hangman_" + tries_remaining + ".png");
  $hangmanImg.attr('src', new_src);
}

function hangmanGameOver(win_boolean){
  $hangmanTries.remove();
  $hangmanForm.remove();
  if (win_boolean){
    $gameResultMessage = $('<h2>').text("You win!!!");
  } else {
    $gameResultMessage = $('<h2>').text("You lose...");
  }
  $hangmanContainer.append($gameResultMessage);
  buildGameResultNavbar("/hangman", $hangmanContainer);
}

function buildGameResultNavbar(newGameRoute, targetContainer){
  $gameResultUl = $("<ul>").attr("class", "game-result-navbar");
  //new game 'button'
  $newGameLi = $("<li>");
  $newGameAnchor = $("<a>").attr('href', newGameRoute).text("New Game");
  //back to all gamez 'button'
  $gamezLi = $("<li>");
  $gamezAnchor = $("<a>").attr('href', "/games").text("Play a different game");
  //put it all together...
  $gameResultUl.append($newGameLi.append($newGameAnchor));
  $gameResultUl.append($gamezLi.append($gamezAnchor));
  targetContainer.append($gameResultUl);
}

// tic-tac-toe **************************************************

function updateTictactoeBoard(board_state){
  board_state_characters = board_state.split('');
  $('.tictactoe-space').each(function(space_index, space){
    $(space.children[0]).text(board_state_characters[space_index]);
  });
}

function updateTictactoeTurn(player1_turn) {
  $('#tictactoe-player-move').text(player1_turn ? "X's move" : "O's move")
}

function handleGameOver(winner) {
  if (winner === "Draw!"){ 
    $('#tictactoe-player-move').text("Draw!")
  } else {
    $('#tictactoe-player-move').text(winner + " wins!")
  }
  var $tictactoeContainer = $($(".tictactoe-container")[0])
  buildGameResultNavbar("/tictactoe", $tictactoeContainer);
}

function highlightWinningSpaces(winning_spaces, winner){
  var $tictactoeSpaces = $('.tictactoe-space');
  $(winning_spaces.split('')).each(function(idx, space_index){
    if (winner === "X"){
      // $($tictactoeSpaces[space_index]).toggleClass('highlighted')
      $($tictactoeSpaces[space_index]).css("border-color", "purple");
    } else {
      $($tictactoeSpaces[space_index]).css("border-color", "chartreuse");
    }
  });
}

function colorXsAndOs(){
  $('.tictactoe-space').each(function(space_index, space){
    var $spaceP = $(space.children[0])
    if ($spaceP.text() === "X"){
      $spaceP.css("color", "purple")
    } else if ($spaceP.text() === "O"){
      $spaceP.css("color", "chartreuse")
    }
  });
}

function validHangmanGuess(guessedLetter){
  removeHangmanEntryError();
  if (guessedLetter.search(/^[-a-zA-Z]$/) >= 0) { // guess is a valid letter or hyphen
    if (hangmanGuessedLetters.indexOf(guessedLetter) >= 0){
      displayHangmanEntryError("'" + guessedLetter.toUpperCase() + "' was already guessed!");
    }
    return true
  } else {
    displayHangmanEntryError("Invalid guess...enter a single letter or hyphen");
    return false;
  }
}

function displayHangmanEntryError(message){
  $errorMessageElement = $('<h3>').text(message).attr("id", "hangman-error-message");
  $hangmanContainer.append($errorMessageElement);
}

function removeHangmanEntryError(){
  $("#hangman-error-message").remove();
}

// after erythang is loaded...

$(function(){
  console.log("Hey there ;)");
  setHangmanConstants();
  colorXsAndOs();

  // guess functionality for hangman
  $(".hangman-submit").on('click', function(e){
    e.preventDefault();
    hangmanGuessedLetters = $($(".hangman-form")[0]).data()['guessedLetters'];
    var guessedLetter = $(".hangman-guess").val().toLowerCase();
    if (validHangmanGuess(guessedLetter)){
      $($(".hangman-form")[0]).data()['guessedLetters'] +=  guessedLetter;
      $.ajax({
        url: $(".hangman-form").attr("action"),
        method: 'POST',
        dataType: "json",
        data: {
          guess: guessedLetter,
        },
        success: function(data) {
          updateHangmanHTML(data.new_display, data.tries);
          updateHangmanImg(data.tries);
          if (data.game_completed) {
            hangmanGameOver(data.win);
          }
        }
      });
    }
  }); // end of hangman guess function

  //move-making functionality for tictactoe
  $('.tictactoe-space').on('click', function(e){
    if (!$tictactoeGameOver){
      var $selectedSpace = $(this);
      var $selectedP = $($selectedSpace.children()[0]);
      var clickedSpace = $selectedP.text();
      var gameID = $("#tictactoe-game-id").attr("value");
      $.ajax({
        url: ('/tictactoe/' + gameID + "/move"),
        method: 'POST',
        dataType: "json",
        data: {
          space_num: clickedSpace,
        },
        success: function(data) {
          console.log(data)
          updateTictactoeBoard(data.new_board_state);
          colorXsAndOs();
          updateTictactoeTurn(data.player1_turn);
          if (clickedSpace.search(/\d/) >= 0){
            $($('.tictactoe-space')[clickedSpace]).toggleClass('hidden');
          }
          if (data.game_completed){
            $tictactoeGameOver = true;
            handleGameOver(data.winner);
            highlightWinningSpaces(data.winning_spaces, data.winner);
          }
        }
      });
    }
  }); // end of tictactoe move

});







