return {
  version = "1.1",
  luaversion = "5.1",
  tiledversion = "0.16.1",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 1,
  height = 1,
  tilewidth = 500,
  tileheight = 500,
  nextobjectid = 8,
  properties = {},
  tilesets = {
    {
      name = "whatever",
      firstgid = 1,
      tilewidth = 500,
      tileheight = 500,
      spacing = 0,
      margin = 0,
      image = "../images/map/All_Colored_Map.png",
      imagewidth = 1963,
      imageheight = 1680,
      tileoffset = {
        x = 0,
        y = 0
      },
      properties = {},
      terrains = {},
      tilecount = 9,
      tiles = {}
    }
  },
  layers = {
    {
      type = "tilelayer",
      name = "Tile Layer 1",
      x = 0,
      y = 0,
      width = 1,
      height = 1,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "lua",
      data = {
        1
      }
    },
    {
      type = "objectgroup",
      name = "whatever i want",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      objects = {
        {
          id = 1,
          name = "",
          type = "",
          shape = "rectangle",
          x = 304,
          y = 300,
          width = 46,
          height = 29,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 4,
          name = "",
          type = "",
          shape = "rectangle",
          x = 302,
          y = 336.5,
          width = 48,
          height = 33,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 5,
          name = "",
          type = "",
          shape = "rectangle",
          x = 256.5,
          y = 338,
          width = 31,
          height = 32,
          rotation = 0,
          visible = true,
          properties = {
            ["collidable"] = "true"
          }
        }
      }
    }
  }
}
