-- ECZ2_10 / Filibuster Rhymes compatibility for Project Zomboid B42.20
-- The original callback exists only in media/lua/client, while vehicle scripts
-- may resolve it on the server. Keep the original no-op contract, but expose it
-- from shared Lua so both sides can find it.

if type(FR_create_blank_part) ~= "function" then
    function FR_create_blank_part(...)
        return nil
    end
end

print("[ECZ B42.20] FR_create_blank_part shared callback loaded")
