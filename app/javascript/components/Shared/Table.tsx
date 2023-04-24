import styled from 'styled-components'

const borderColor = '#D6D3D0'

export const Table = styled.table`
  height: 100%; /* cell 内の要素の高さを 100% にするために必要 */
  width: 100%;
`
export const TableHead = styled.thead``
export const TableRow = styled.tr``
export const TableBody = styled.tbody`
  > tr:first-child > td {
    padding-top: 16px;
  }
`
export const TableHeadCell = styled.th<{ width?: string, minWidth?: string, textCenter?: boolean }>`
  padding: 16px;
  font-size: 14px;
  border: solid 1px ${borderColor};
  width: ${({width}) => width ? width : 'auto'};
  min-width: ${({minWidth}) => minWidth ? minWidth : 'auto'};
  text-align: ${({textCenter}) => textCenter ? 'center' : 'left'};
`
export const TableBodyCell = styled.td<{ noSidePadding?: boolean }>`
  padding: ${({ noSidePadding }) => noSidePadding ? '8px 0' : '8px'};
`
