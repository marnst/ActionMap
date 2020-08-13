# frozen_string_literal: true

class Representative < ApplicationRecord
    has_many :news_items, dependent: :delete_all

    def self.civic_api_to_representative_params(rep_info)
        reps = []
        rep_info.officials.each_with_index do |official, index|
            title_temp, ocdid_temp = each_helper(rep_info, index)
            rep = Representative.create!({ name: official.name, ocdid: ocdid_temp,
                                           title: title_temp, address: address_helper(official.address),
                                           party: official.party, photo: photo_helper(official.photo_url) })
            reps.push(rep)
        end
        reps
    end

    def self.each_helper(rep_info, index)
        ocdid_temp = ''
        title_temp = ''
        rep_info.offices.each do |office|
            if office.official_indices.include? index
                title_temp = office.name
                ocdid_temp = office.division_id
            end
        end
        [title_temp, ocdid_temp]
    end

    def self.photo_helper(photo)
        if photo.blank? || photo.empty?
            'https://raw.githubusercontent.com/datamade/my-reps/master/images/blank-person.jpg'
        else
            photo
        end
    end

    def self.address_helper(address)
        return address if address.blank?

        check = address.to_s.tr('""', '')
        vals = regex_helper(check)
        addy = ''
        vals.each do |val|
            addy += if val.blank?
                        ''
                    else
                        "#{val[0][0]} "
                    end
        end
        addy
    end

    def self.regex_helper(check)
        line1 = check.scan(/(?<=@line1=)(.*?)(?=,|>)/)
        line2 = check.scan(/(?<=@line2=)(.*?)(?=,|>)/)
        line3 = check.scan(/(?<=@line3=)(.*?)(?=,|>)/)
        city = check.scan(/(?<=@city=)(.*?)(?=,|>)/)
        state = check.scan(/(?<=@state=)(.*?)(?=,|>)/)
        zip = check.scan(/(?<=@zip=)(.*?)(?=,|>)/)
        [line1, line2, line3, city, state, zip]
    end
end
