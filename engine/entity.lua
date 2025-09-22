
Component = {}

function Component:new()
    local new = {}

    local methods = {}
    methods.__index = methods
    new.methods = methods

    return new
end

Entity = {}
Entity.__index = Entity

function Entity:new()
    local new = setmetatable({}, self)
    new.components = {}
    return new
end

function Entity:update()
    for c, v in pairs(self.components) do
        if c.update then c.update(v) end
    end
end

function Entity:addComponent(component)
    local new = setmetatable({}, component.methods)
    self.components[component] = new
    if component.added then component.added(new, self) end
end

function Entity:getComponent(component)
    return self.components[component]
end
