class Url < ActiveRecord::Base
    belongs_to :user 

    def shorten_id
        id.to_s(32)
    end

    def self.find_by_base58(base58)
        id = decode_base58(base58)
        self.find_by_id(id)
    end

    def shorten
        "http://localhost9393#{shorten_id}"
    end

    def self.decode_base58(base58)
        base58.to_i(32)
    end

    def valid_url?
        url.match?(/^((https?|ftp|smtp):\/\/)?(www.)?[a-z0-9]+\.[a-z]+(\/[a-zA-Z0-9#]+\/?)*$/)
    end
end
