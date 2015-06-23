-- ObjectFuncs.moon

HiddenPropertyName = (item, propName) ->
  propName = tostring propName
  if not propName\match '[%w_]+' then return false
  if is('UserData', item)  -- Built-in data type (RBLX)
    '_' + item.ClassName + '_' + propName
  else
    '_' + item.__class.__name + '_' + propName

is = (T, obj) -> type(obj) == T

IsUserData = (obj) -> type(obj) == 'UserData'

del = (list) ->
  for item in *list
    if is('UserData', item) and item.Destroy  -- RBLX Class
      item\Destroy!
    elseif Del = item[HiddenPropertyName(item, 'del')]
      Del item

{
  :del
  :HiddenPropertyName
  :IsUserData
  delete: del
}