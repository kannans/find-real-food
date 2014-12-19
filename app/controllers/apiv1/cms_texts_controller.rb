class Apiv1::CmsTextsController < ApplicationController
  api :GET, '/cms_texts', 'Get all admin editable text snippets'
  def index
    @texts = CmsText.all
    respond_to do |format|
      format.json { render_for_api :cms_text, :json => @texts,
        :meta => { :success => true} }
    end
  end
end
