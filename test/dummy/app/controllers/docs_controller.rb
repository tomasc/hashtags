class DocsController < ApplicationController
  before_action :set_doc, only: [:show, :edit, :update, :destroy]

  def show
  end

  def new
    @doc = Doc.new
  end

  def create
    @doc = Doc.new(doc_params)

    respond_to do |format|
      if @doc.save
        format.html { redirect_to @doc, notice: 'Doc was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  private

  def set_doc
    @doc = Doc.find(params[:id])
  end

  def doc_params
    params.fetch(:doc, {}).permit(:text)
  end
end
