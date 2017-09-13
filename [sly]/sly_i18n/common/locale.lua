-- -
-- Internationalization module.
--
--

Locales = {}

-- -
-- Returns the correct translation according
-- to the given slug.
--
-- @param  {String}  slug  - Slug used to find the translation
-- @param  {Table}  ...    - Text to use while translating
--
-- @return {String}
--
function _(slug, ...)
  if Locales[Config.Locale] ~= nil then

    if Locales[Config.Locale][slug] ~= nil then
      return string.format(Locales[Config.Locale][slug], ...)
    else
      return 'Translation - [' .. Config.Locale .. '][' .. slug .. '] - does not exists'
    end

  else
    return 'Locale - [' .. Config.Locale .. '] - does not exists'
  end
end

-- -
-- Returns the correct translation according to the given
-- slug with the first letter in Uppercase.
--
-- @param  {String}  slug  - Slug used to find the translation
-- @param  {Table}  ...    - Text to use while translating
--
-- @return {String}
--
function _U(str, ...)
  return tostring(_(str, ...):gsub("^%l", string.upper))
end
