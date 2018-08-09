module Flexhub
  module Render
    def flexhub_render_partial(item)
      render partial: "flexhub/partials/table", locals: { content: item }
    end

    def flexhub_respond(item)
      respond_to do |format|
        format.html { flexhub_render_view(item) }
        format.xml { render xml: item }
        format.json { render json: item }

        format.csv do
          exporter = eval("#{item.class}::Exporter")
          if exporter && exporter.methods.include?(:to_csv)
            render plain: exporter.to_csv(item)
          else
            head :not_implemented
          end
        end
      end
    end

    def flexhub_render_view(item)
      render "flexhub/view", locals: { content: item }
    end
  end
end
