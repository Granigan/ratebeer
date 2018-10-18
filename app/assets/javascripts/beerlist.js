const BEERS = {}

BEERS.show = () => {
  const beer_list = []

  BEERS.list.forEach((beer) => {
    beer_list.push('<li>' + beer['name'] + '</li>')
  })

  $('#beers').html('<ul>' + beer_list.join('') + '</ul>')
}

BEERS.reverse = () => {
  BEERS.list.reverse()
}

document.addEventListener("turbolinks:load", () => {
  $("#reverse").click((e) => {
    e.preventDefault()
    BEERS.reverse()
    BEERS.show()
  })

  $.getJSON('beers.json', (beers) => {
    BEERS.list = beers
    BEERS.show()
  })
})
