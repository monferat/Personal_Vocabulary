class VocabularyAPI::Version1::Themes < Grape::API

  #/api/v1/themes/all
  desc 'Get all themes'
  get 'themes/all', jbuilder: 'themes/themes' do
    @themes = Theme.all
  end

end
