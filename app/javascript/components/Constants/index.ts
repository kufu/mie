import { createTheme } from 'smarthr-ui'

export const createdTheme = createTheme({
  fontSize: {
    htmlFontSize: 10,
    S: '1.1rem',
    M: '1.4rem',
    L: '1.8rem',
    XL: '2.4rem',
  },
})
const {
  palette: defaultPalette,
  color: defaultColor,
  size: defaultSize,
  fontSize: defaultFontSize,
  spacing: defaultSpacing,
  frame: defaultFrame,
  border: defaultBoarder,
  radius: defaultRadius,
  interaction: defaultInteraction,
  shadow: defaultShadow,
} = createdTheme

const appColor = {
  WHITE: '#fff',
  YELLOW: '#ffcc00',
  BLUE: '#0081cc',
  LIGHT_YELLOW: '#fffcf0',
  LIGHT_GREEN: '#c8e5c9',
  LIGHT_BLUE: '#bbddfb',
  DARK_GREEN: '#064d09',
  DARK_BLUE: '#054075',
  DEEP_BLUE: '#54647d',
  DEEP_BLUE_P10: '#414e62',
} as const
export const palette = {
  ...defaultPalette,
  ...appColor,
}
export const color = {
  ...defaultColor,
  ...appColor,
} as const
export const size = {
  pxToRem: defaultSize.pxToRem,
  font: {
    SHORT: defaultSize.pxToRem(defaultSize.font.SHORT),
    TALL: defaultSize.pxToRem(defaultSize.font.TALL),
    GRANDE: defaultSize.pxToRem(defaultSize.font.GRANDE),
    VENTI: defaultSize.pxToRem(defaultSize.font.VENTI),
  },
  space: {
    XXS: defaultSize.pxToRem(defaultSize.space.XXS),
    XS: defaultSize.pxToRem(defaultSize.space.XS),
    S: defaultSize.pxToRem(defaultSize.space.S),
    M: defaultSize.pxToRem(defaultSize.space.M),
    L: defaultSize.pxToRem(defaultSize.space.L),
    XL: defaultSize.pxToRem(defaultSize.space.XL),
    XXL: defaultSize.pxToRem(defaultSize.space.XXL),
  },
  spaceNumeric: {
    XXS: defaultSize.space.XXS,
    XS: defaultSize.space.XS,
    S: defaultSize.space.S,
    M: defaultSize.space.M,
    L: defaultSize.space.L,
    XL: defaultSize.space.XL,
    XXL: defaultSize.space.XXL,
  },
}
export const fontSize = defaultFontSize
export const border = defaultBoarder
export const radius = defaultRadius
export const interaction = defaultInteraction
export const shadow = defaultShadow