require "ISUI/ISPanel"
require "Entity/ISUI/CraftRecipe/ISWidgetRecipeCategories"

function ISWidgetRecipeCategories:populateCategoryList()
    self.recipeCategoryPanel:clear();
    self.recipeCategoryPanel:addItem(getText("IGUI_RecipecategoryAll"), "");
    self.recipeCategoryPanel:addItem(getText("IGUI_RecipecategoryFavorite"), "*");

    local currentCategoryFilterFound = self.selectedCategory == "";

    if self.selectedCategory == "*" then
        self.recipeCategoryPanel.selected = 2;
        currentCategoryFilterFound = true;
    end

    local categories = self.callbackTarget:getCategoryList();
	local categoriesTable = {};
	for i = 0, categories:size() - 1 do
		local categoryNameCapitalised = string.upper(string.sub(categories:get(i), 1, 1)) .. string.sub(categories:get(i), 2, string.len(categories:get(i)));
		local translationKey = "IGUI_Recipecategory_" .. categoryNameCapitalised;
		local translatedText = getText(translationKey);
		if translatedText == translationKey then
			translatedText = categories:get(i);
		end
		table.insert(categoriesTable, {original = categories:get(i), translated = translatedText});
	end
	table.sort(categoriesTable, function(a, b) return a.translated:lower() < b.translated:lower(); end)
	for i, categoryData in ipairs(categoriesTable) do
		local item = self.recipeCategoryPanel:addItem(categoryData.translated, categoryData.original);
		
		if categoryData.original == self.selectedCategory then
			self.recipeCategoryPanel.selected = item.itemindex;
			currentCategoryFilterFound = true;
		end	
	end

    if not currentCategoryFilterFound then
        -- reset filter
        self:onCategoryChanged("");
    end

    if categories:size() > 0 then
        self.isInitialised = true;
    end
end
